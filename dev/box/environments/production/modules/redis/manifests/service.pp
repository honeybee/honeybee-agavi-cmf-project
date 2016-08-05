class redis::service {
  file { "/etc/redis/berlinonline.conf" :
    content => template('redis/redis.conf.erb'),
    require => Package[$::redis::packagename],
    notify  => Service["redis@berlinonline.service"]
  }
  service { 'redis' :
    ensure  => running,
    enable  => true,
    name    => "redis@berlinonline.service",
    require => File['/etc/redis/berlinonline.conf']
  }
}
