define nginx::server::location (
  $content = "",
  $location = $name,

  $ensure = present,
  $server = undef,
  $location_config_header_template = "nginx/conf.d/location_header.conf.erb",
  $location_config_footer_template = "nginx/conf.d/location_footer.conf.erb",
  $order = "050+$name",
) {
  include nginx::base

  if $server == undef {
    fail("Please provide a $server for this location")
  }

  if is_string($server) {
    fail("Please provide a Nginx::Server as $server for this location")
  }

  $server_config_file_name = getparam($server, "server_config_file_name")

  concat::fragment{ "${server_config_file_name}_location_${name}_header":
    ensure => $ensure,
    target => $server_config_file_name,
    content => template($location_config_header_template),
    order => "$order+001",
  }

  if $content != "" {
    concat::fragment{ "${server_config_file_name}_location_${name}_body":
      ensure => $ensure,
      target => $server_config_file_name,
      content => $content,
      order => "$order+090",
    }
  }

  concat::fragment{ "${server_config_file_name}_location_${name}_footer":
    ensure => $ensure,
    target => $server_config_file_name,
    content => template($location_config_footer_template),
    order => "$order+099",
  }

}
