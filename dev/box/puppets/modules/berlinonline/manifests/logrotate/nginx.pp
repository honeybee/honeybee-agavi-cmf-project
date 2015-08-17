# Class: berlinonline::logrotate::honeybee_queue_stats
#
#
class berlinonline::logrotate::nginx inherits berlinonline{
  logrotate::rule { 'nginx_access':
    ensure        => 'present',
    path          => '/var/log/nginx/*access*.log',
    rotate        => 5,
    rotate_every  => 'day',
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
  logrotate::rule { 'nginx_error':
    ensure        => 'present',
    path          => '/var/log/nginx/*error*.log',
    rotate        => 30,
    rotate_every  => 'day',
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