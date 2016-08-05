define rabbitmq::user (String $user, String $password) {
    exec { "add_user ${user}":
      command => "rabbitmqctl add_user ${user} ${password}",
      path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
      unless  => "/usr/sbin/rabbitmqctl list_users | grep -w ${user}"
    }
}