# Class: berlinonline::logrotate::php_slow_log
#
#
class berlinonline::logrotate::php_slow_log{
  logrotate::rule { 'php_fpm_slow_log':
    ensure        => 'present',
    path          => '/var/log/php/*.log',
    rotate        => 1,
    rotate_every  => 'day',
    size          => '30M',
    sharedscripts => true,
    compress      => true,
    delaycompress => true,
    missingok     => true,
    copytruncate  => true,
    create        => true,
    create_mode   => "0640",
    create_owner  => $berlinonline::scm_user,
    create_group  => $berlinonline::scm_user,
    
  }
}