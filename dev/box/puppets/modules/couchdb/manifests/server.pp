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
  package { 'couchdb':
    ensure => installed
  }
  service { 'couchdb':
    ensure  => running,
    enable  => true,
    require => Package[couchdb],
  }
}
