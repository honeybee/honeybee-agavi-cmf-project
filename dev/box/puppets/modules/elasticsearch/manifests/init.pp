# == Class: elasticsearch
#
# Full description of class elasticsearch here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*version*]
#   enables deployment of different elasticsearch version, currently only 1.4.4 and 1.5.1
#
# === Examples
#
#  class { 'elasticsearch':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2015 Your name here, unless otherwise noted.
#
class elasticsearch(
  $version                                = '1.4.4',
  $es_directory                           = '/usr/share/elasticsearch',
  $network_host                           = '127.0.0.1',
  $discovery_zen_ping_multicast_enabled   = false,
  $node_local                             = true,
  $script_disable_dynamic                 = true,
  $cluster_name                           = $::fqdn,
  $node_master                            = true,
  Integer $index_replica                  = 1,
  Boolean $unicast_multi_mode             = false,
)
{
  require ::elasticsearch::requirements
  if $unicast_multi_mode {
    $_unicast_nodes = query_nodes("Class['elasticsearch']{ cluster_name = '${cluster_name}' }", ipaddress)
  }
  case $::operatingsystem {
    'OpenSuSE': {
      package { "elasticsearch${::elasticsearch::version}":
        #puppet zypper seems buggy in this case when installing packages with version he places the "=" with a "-", that doesnt work
        ensure => present,
      }
    }
    default: {
      fail{ 'This module currently only supports OpenSuSE' :}
    }
  }
  service { 'elasticsearch':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }
  file { '/etc/elasticsearch/elasticsearch.yml':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    content => template('elasticsearch/elasticsearch.yml.erb'),
    notify  => Service['elasticsearch']
  }
  ->
  augeas { 'elasticsearch_sysconfig':
    context => '/files/etc/sysconfig/elasticsearch',
    changes => [
      "set ES_CLUSTER_NAME ${cluster_name}",
      "set ES_NODE_NAME ${::fqdn}",
    ],
    notify  => Service['elasticsearch'],
  }
}
