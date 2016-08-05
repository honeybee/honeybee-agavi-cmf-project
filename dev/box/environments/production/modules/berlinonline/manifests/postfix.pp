# Class: berlinonline::postfix
#
# basic config for postfix on server
class berlinonline::postfix {
  #below puppet 4.4.0 puppet use rpm instead of zypper for deinstallation, rpm does not solve deps correctly
  exec { '/usr/bin/zypper --non-interactive remove exim':
    path   => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/share/java/elasticsearch/bin' ],
    onlyif => 'ls /usr/sbin/exim',
  }
  ->
  class { '::postfix::server':
    myhostname              => $::fqdn,
    mydestination           => '',
    inet_interfaces         => 'loopback-only',
    smtp_tls_security_level => 'may',
  }
}