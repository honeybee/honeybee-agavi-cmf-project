define rabbitmq::vhost (String $vhost) {
    exec { "add_vhost ${vhost}":
      command => "rabbitmqctl add_vhost ${vhost}",
      path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
      unless  => "/usr/sbin/rabbitmqctl list_vhosts | grep -w ${vhost}"
    }
}