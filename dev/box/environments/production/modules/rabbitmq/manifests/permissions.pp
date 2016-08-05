define rabbitmq::permissions (String $user, String $vhost) {
  exec { "add_permission for ${user} to ${vhost}":
      command => "rabbitmqctl set_permissions -p ${vhost} ${user} \".*\" \".*\" \".*\"",
      path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
      unless  => "/usr/sbin/rabbitmqctl list_permissions -p ${vhost} | grep -w ${user}"
    }
}