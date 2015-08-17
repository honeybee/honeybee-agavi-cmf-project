define nginx::server::location::alias (
  $directory = undef,
  $content = undef,
  $config_template = "nginx/conf.d/location/alias.conf.erb",

  $location	= undef,
  $ensure = present,
  $order = "050",
) {
  validate_absolute_path($directory)

  nginx::server::location::fragment { "alias_${name}":
    content => template($config_template),

    location => $location,
    ensure => $ensure,
    order => $order,
  }
}
