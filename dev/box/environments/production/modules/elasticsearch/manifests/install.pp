# Class: elasticsearch::install
#
#
class elasticsearch::install {
  case $::operatingsystem {
    'OpenSuSE': {
      case $::elasticsearch::branch {
        /^2\.3/: {
          zypprepo { 'OpenSuse_Elasticsearch':
            baseurl      => "http://download.opensuse.org/repositories/home:/BerlinOnline:/elasticsearch:/2.3.x/openSUSE_${::operatingsystemrelease}/",
            enabled      => 1,
            autorefresh  => 1,
            name         => 'OpenSuse_Elasticsearch 2.3',
            gpgcheck     => 0,
            priority     => 98,
            keeppackages => 1,
            type         => 'rpm-md',
            before       => Exec['zypper-refresh']
          }
        }
        /^1\.5/: {
          zypprepo { 'OpenSuse_Elasticsearch':
            baseurl      => "http://download.opensuse.org/repositories/home:/BerlinOnline:/elasticsearch:/1.5.x/openSUSE_${::operatingsystemrelease}/",
            enabled      => 1,
            autorefresh  => 1,
            name         => 'OpenSuse_Elasticsearch 1.5',
            gpgcheck     => 0,
            priority     => 98,
            keeppackages => 1,
            type         => 'rpm-md',
            before       => Exec['zypper-refresh']
          }
        }
      }
      package { 'elasticsearch':
        ensure  => present,
        require => Zypprepo['OpenSuse_Elasticsearch']
      }
    }
    default: {
      crit ('This module currently only supports OpenSuSE')
    }
  }
}