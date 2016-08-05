define rabbitmq::plugin  {
    exec { "installing plugin ${name}":
      command     => "rabbitmq-plugins enable ${name}",
      path        => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
      environment => 'HOME=/root',
      unless      => "/usr/sbin/rabbitmq-plugins list -e | grep -w ${name}",
      notify      => Service['rabbitmq-server']
    }
}