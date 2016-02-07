# Class: elasticsearch::requirements
#
#
class elasticsearch::requirements {
  file { '/etc/elasticsearch' :
    ensure => directory
  }
  case $::operatingsystem {
    'OpenSuSE': {
      zypprepo { 'OpenSuse_Elasticsearch':
        baseurl      =>
        "http://download.opensuse.org/repositories/home:/loosi:/work:/elasticsearch/openSUSE_${::operatingsystemrelease}/",
        enabled      => 1,
        autorefresh  => 1,
        name         => 'OpenSuse_Elasticsearch',
        gpgcheck     => 0,
        priority     => 98,
        keeppackages => 1,
        type         => 'rpm-md',
      }
    }
    default: {
      fail{ 'This module currently only supports OpenSuSE' :}
    }
  }
}
