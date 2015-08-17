define ssh::user(
  $user = "${name}",
  $home = "/home/${name}"
) {

  User[$user] -> File[$home] -> file { "${home}/.ssh/":
    ensure => directory,
    owner  => $user,
    group  => $user,
    mode   => '0700'
  } -> file { "${home}/.ssh/known_hosts":
    ensure  => present,
    content => template('ssh/user/known_hosts.erb'),
    owner   => $user,
    group   => $user,
    mode    => '0644'
  }

}
