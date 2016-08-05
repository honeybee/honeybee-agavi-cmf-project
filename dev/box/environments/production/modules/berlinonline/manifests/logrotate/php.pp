# Class: berlinonline::logrotate::php
#
#
class berlinonline::logrotate::php
(
    $retention_time = '5'
) {
  logrotate::rule { 'php':
    ensure        => 'present',
    path          => '/var/log/php/*.log',
    rotate        => $retention_time,
    rotate_every  => 'day',
    sharedscripts => true,
    compress      => true,
    delaycompress => true,
    missingok     => true,
    create        => true,
    create_mode   => '0640',
    create_owner  => $berlinonline::scm_user,
    create_group  => $berlinonline::scm_user,
    postrotate    => '[ ! -f /var/run/php-fpm/php-fpm.pid ] || kill -USR1 `cat /var/run/php-fpm/php-fpm.pid`'
  }
  logrotate::rule { 'php-fpm':
    ensure        => 'present',
    path          => '/var/log/php-fpm/*.log',
    rotate        => $retention_time,
    rotate_every  => 'day',
    sharedscripts => true,
    compress      => true,
    delaycompress => true,
    missingok     => true,
    create        => true,
    create_mode   => '0640',
    create_owner  => $berlinonline::scm_user,
    create_group  => $berlinonline::scm_user,
    postrotate    => '[ ! -f /var/run/php-fpm/php-fpm.pid ] || kill -USR1 `cat /var/run/php-fpm/php-fpm.pid`'
  }
}