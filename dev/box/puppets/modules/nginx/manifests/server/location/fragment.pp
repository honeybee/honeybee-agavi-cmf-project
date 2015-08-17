#
# This is ONLY used by the other location::* types. Please do not invoke it directly!
#
define nginx::server::location::fragment (
  $location	= undef,
  $content = undef,
  $ensure = present,
  $order = undef,
) {
  if $location == undef {
    fail("Please provide a $location for this fragment")
  }

  if is_string($location) {
    fail("Please provide a Nginx::Server::Location as $location for this fragment")
  }

  validate_string($content)
  validate_string($order)

  $server = getparam($location, "server")
  $server_config_file_name = getparam($server, "server_config_file_name")
  $location_order = getparam($location, "order")

  if $content != "" {
    concat::fragment{ "${server_config_file_name}_location_${name}":
      ensure => $ensure,
      target => $server_config_file_name,
      content => $content,
      order => "$location_order+$order",
    }
  }
}
