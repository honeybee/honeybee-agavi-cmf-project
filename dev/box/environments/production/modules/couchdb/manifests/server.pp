# == Class: Couchdb::server
class couchdb::server {
  file { '/etc/couchdb':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
  }
  ->
  file{'local.ini':
    ensure  => present,
    path    => '/etc/couchdb/local.ini',
    mode    => '0644',
    owner   => 'couchdb',
    group   => 'root',
    content => template('couchdb/local.ini.erb'),
    notify  => Service['couchdb'],
    require => Package[couchdb]
  }
  file { '/etc/couchdb/local.d/bo.ini':
    ensure  => 'present',
    mode    => '0644',
    content => template('couchdb/bo.ini.erb'),
    require => Package[couchdb],
  }
  case $::couchdb::version {
    '1.6.0': {}
    '1.6.1', 'latest', default : {
      zypprepo { 'mruediger_couchdb':
        baseurl      =>
        "http://download.opensuse.org/repositories/home:/loosi:/work:/couchdb/openSUSE_${::operatingsystemrelease}/",
        enabled      => 1,
        autorefresh  => 1,
        name         => 'OpenSuse_mruediger_couchdb',
        gpgcheck     => 0,
        priority     => 98,
        keeppackages => 1,
        type         => 'rpm-md',
      }
    }
  }
  package { 'couchdb':
    ensure => installed
  }
  service { 'couchdb':
    ensure  => running,
    enable  => true,
    require => Package[couchdb],
  }
}
