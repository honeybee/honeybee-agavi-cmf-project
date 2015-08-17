# Class: berlinonline::logrotate::honeybee
#
#
class berlinonline::logrotate::honeybee{
    logrotate::rule { 'honeybee':
      ensure        => 'present',
      path          => "${berlinonline::webdirectory}/${berlinonline::cms_name}/app/log/*.log",
      rotate        => 30,
      rotate_every  => 'day',
      sharedscripts => true,
      compress      => true,
      delaycompress => true,
      missingok     => true,
      copytruncate  => true,
    }
}