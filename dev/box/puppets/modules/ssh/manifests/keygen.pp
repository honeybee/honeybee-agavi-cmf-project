define ssh::keygen(
  $user,
  $home = "/home/${user}",
  $comment = $title,
  $keyname = undef
) {

  if $user == undef {
    fail('You must specify a valid (ssh) user name!')
  }

  if $home == undef {
    $home_real = "/home/${user}"
  } else {
    $home_real = $home
  }

  if $keyname == undef {
    if $comment == $title {
      $keyname_real = "id_rsa"
    } else {
      $keyname_real = "id_rsa_${comment}"
    }
  }
  else {
    $keyname_real = $keyname
  }

  Ssh::User[$user]
  -> exec { "ssh-keygen-for-${user}":
    command => "ssh-keygen -t rsa -f \"${home_real}/.ssh/${keyname_real}\" -N '' -C '${comment}'",
    creates => "${home_real}/.ssh/${keyname_real}",
    user    => $user,
    group   => $user,
    path    => ['/bin', '/usr/bin', '/usr/sbin', '/usr/local/bin'],
    unless  => "cat ${home_real}/.ssh/${keyname_real} 2>/dev/null",
  }

}
