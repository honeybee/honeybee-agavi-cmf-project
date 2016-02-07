# Class: berlinonline::roles::rabbitmq
#
#
class berlinonline::roles::rabbitmq {
  require '::rabbitmq'
  include '::berlinonline::locale'

  $pw = fqdn_rand_string(20)

  Rabbitmq::User { $::berlinonline::rabbit_user :
    user     => $::berlinonline::rabbit_user,
    password => $pw,
  }
  ->
  exec {'create_rabbit_local_file':
    command => "/bin/echo \'---\n# rabbitmq credentials\nrabbitmq:\n  user: ${::berlinonline::rabbit_user}\n  password: $pw\n  host: localhost\n  port: 5672\' > ${::berlinonline::locale_dir}/${::berlinonline::application_name}/rabbitmq.yaml",
    unless  => "/usr/bin/test -f ${::berlinonline::locale_dir}/${::berlinonline::application_name}/rabbitmq.yaml",
    require => File["${::berlinonline::locale_dir}/${::berlinonline::application_name}"]
  }
  ->
  exec {'create_rabbit_local_file_json':
    command => "/bin/echo \'{\"rabbitmq\":{\"user\":\"${::berlinonline::rabbit_user}\",\"password\":\"$pw\",\"host\":\"localhost\",\"port\":5672}}\' > ${::berlinonline::locale_dir}/${::berlinonline::application_name}/rabbitmq.json",
    unless  => "/usr/bin/test -f ${::berlinonline::locale_dir}/${::berlinonline::application_name}/rabbitmq.json",
    require => File["${::berlinonline::locale_dir}/${::berlinonline::application_name}"]
  }
  ->
  Rabbitmq::Vhost { $::berlinonline::rabbit_vhost :
    vhost => $::berlinonline::rabbit_vhost
  }
  ->
  Rabbitmq::Permissions { $::berlinonline::rabbit_vhost :
    vhost => $::berlinonline::rabbit_vhost,
    user  => $::berlinonline::rabbit_user
  }

}
