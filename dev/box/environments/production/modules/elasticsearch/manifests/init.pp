# == Class: elasticsearch
#
# Full description of class elasticsearch here.
#
# [*branch*]
#   enables deployment of different elasticsearch branches, currently only 1.5 and 2.3

# === Authors
#
# Maximilian Rüdiger <maximilian.ruediger@berlinonline.de>
#
#
class elasticsearch(
  String $branch                          = '2.3',
  $network_host                           = '127.0.0.1',
  $discovery_zen_ping_multicast_enabled   = false,
  $node_local                             = true,
  $enable_script_inline                   = off,
  $enable_script_indexed                  = off,
  $cluster_name                           = $::fqdn,
  $node_master                            = true,
  Integer $index_replica                  = 1,
  Boolean $unicast_multi_mode             = false,
  String $heap_size                       = "1G",
  $slowlog_threshold_query_warn           = false,
  $slowlog_threshold_query_info           = false,
  $slowlog_threshold_query_debug          = false,
  $slowlog_threshold_query_trace          = false,

)
{
  file { '/etc/elasticsearch' :
    ensure => directory
  }
  require ::elasticsearch::validator
  require ::elasticsearch::install
  
  if $unicast_multi_mode {
    $_unicast_nodes = query_nodes("Class['elasticsearch']{ cluster_name = '${cluster_name}' }", ipaddress)
  }
  
  service { 'elasticsearch':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }
  if $::elasticsearch::branch =~ /1\.*/ {
    $branch_internal = 'v1'
    $es_directory    = '/usr/share/elasticsearch'
  }
  else {
    $branch_internal = 'v2'
    $es_directory    = '/usr/share/java/elasticsearch'
  }
  file { '/etc/elasticsearch/elasticsearch.yml':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    content => template("elasticsearch/${branch_internal}/elasticsearch.yml.erb"),
    notify  => Service['elasticsearch']
  }
  ->
  augeas { 'elasticsearch_sysconfig':
    context => '/files/etc/sysconfig/elasticsearch',
    changes => [
      "set ES_CLUSTER_NAME ${cluster_name}",
      "set ES_NODE_NAME ${::fqdn}",
      "set ES_HEAP_SIZE ${heap_size}"
    ],
    notify  => Service['elasticsearch'],
  }
}
