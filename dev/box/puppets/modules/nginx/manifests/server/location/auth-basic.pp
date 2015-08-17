define nginx::server::location::auth-basic (
  $text = undef,
  $user_file = undef,
  $content = undef,
  $config_template = "nginx/conf.d/location/auth-basic.conf.erb",

  $location = undef,
  $ensure = present,
  $order = "050",
) {
  validate_string($text)
  validate_absolute_path($user_file)

  nginx::server::location::fragment { "auth-basic_${name}":
    content => template($config_template),

    location => $location,
    ensure => $ensure,
    order => $order,
  }
}
