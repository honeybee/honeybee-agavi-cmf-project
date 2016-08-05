# Class: berlinonline::logrotate::nginx
#
#
class berlinonline::logrotate::nginx
(
    $retention_time = '5'
) {
  logrotate::rule { 'nginx':
    ensure        => 'present',
    path          => '/var/log/nginx/*.log',
    rotate        => $retention_time,
    rotate_every  => 'day',
    sharedscripts => true,
    compress      => true,
    delaycompress => true,
    missingok     => true,
    create        => true,
    postrotate    => '[ ! -f /var/run/nginx.pid ] || kill -USR1 `cat /var/run/nginx.pid`'
  }
}