define rabbitmq::tag (String $user, String $user_tag) {
    exec { "setting tag ${user_tag} on user ${user}":
      command => "rabbitmqctl set_user_tags ${user} ${user_tag}",
      path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
      unless  => "/usr/sbin/rabbitmqctl list_users |grep -w ${user_tag}"
    }
}