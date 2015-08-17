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
  $version      = '1.4.4',
  $es_directory = '/usr/share/elasticsearch',
)
{
  require ::elasticsearch::requirements
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
}
