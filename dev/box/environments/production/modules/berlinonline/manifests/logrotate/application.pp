# Class: berlinonline::logrotate::honeybee
#
#
class berlinonline::logrotate::application
(
  $retention_time = '10'
){
  # logrotate::rule { 'application-honeybee' :
  #   ensure        => 'present',
  #   path          => "${berlinonline::webdirectory}/${berlinonline::application_name}/app/log/*.log",
  #   rotate        => $retention_time,
  #   rotate_every  => 'day',
  #   sharedscripts => true,
  #   compress      => true,
  #   delaycompress => true,
  #   missingok     => true,
  #   copytruncate  => true,
  #   copy          => true,
  # }
  logrotate::rule { 'application-silex' :
    ensure        => 'present',
    path          => "${berlinonline::webdirectory}/${berlinonline::application_name}/var/logs/*.log",
    rotate        => $retention_time,
    rotate_every  => 'day',
    sharedscripts => true,
    compress      => true,
    delaycompress => true,
    missingok     => true,
    copytruncate  => true,
  }
}
