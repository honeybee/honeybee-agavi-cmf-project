# Class: couchdb::legacy
#
#
class couchdb::legacy {
  apt::source { 'CouchDB Precise PPA':
    location          => 'http://ppa.launchpad.net/nilya/couchdb-1.2/ubuntu',
    repos             => 'main',
  }
  ->
  package { 'couchdb':
    ensure => latest
  }
  #the default init.d script for ubunut couchdb is broken in precise
  #adding upstart script from trusty
  file { '/etc/init.d/couchdb' :
    ensure => absent
  }
  file { '/etc/init/couchdb.conf' :
    ensure  => present,
    content => template('couchdb/couchdb_upstart.erb')
  }
  
  #set up compaction
  #couchdb has a compaction daemon up from 1.2.*, but this daemon wont work with wildcards so we would need to    define every database manually...as for a ugly fix we use a script
  cron { 'compact-couchdb':
    command => '/usr/bin/compact_couchdb',
    ensure  => present,
    user    => root,
    hour    => 3,
    require => Package['rubygems']
  }
  file { '/usr/bin/compact_couchdb':
    ensure  =>  file,
    owner   =>  'root',
    group   =>  'root',
    mode    =>  '0700',
    content =>  template('couchdb/compact_couchdb.erb'),
    require =>  Package['rubygems']
  }
  file {'/etc/couchdb/local.d/berlinonline.ini':
    ensure  =>  file,
    owner   =>  'couchdb',
    group   =>  'couchdb',
    content =>  template('couchdb/custom_config.erb'),
    require =>  Package['couchdb'],
    notify  =>  Service['couchdb']
  }
  service { 'couchdb':
    ensure    => running,
    name      => 'couchdb',
    enable    => true,
    require   => Package['couchdb'],
  }

}