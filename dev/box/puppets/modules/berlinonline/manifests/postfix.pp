# Class: berlinonline::postfix
#
# basic config for postfix on server
class berlinonline::postfix {
  class { '::postfix::server':
    myhostname              => ::fqdn,
    mydestination           => '',
    inet_interfaces         => 'loopback-only',
    smtp_tls_security_level => 'may',
  }
}