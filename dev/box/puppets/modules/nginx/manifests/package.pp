# Class: nginx::package
#
# deploy the nginx packages for different OS
class nginx::package (
  $ensure = present
) {
  case $::osfamily {
    'debian': {
      package{ 'nginx':
        ensure => $ensure
      }
    }
    'Suse': {
      zypprepo { "OpenSuse_${::operatingsystemrelease}_http":
        baseurl      => "http://download.opensuse.org/repositories/server:/http/openSUSE_${::operatingsystemrelease}/",
        enabled      => 1,
        autorefresh  => 1,
        name         => "openSUSE_${::operatingsystemrelease}_http",
        gpgcheck     => 0,
        priority     => 98,
        keeppackages => 1,
        type         => 'rpm-md',
      }->
      package{ 'nginx':
        ensure => $ensure
      }
    }
    default: {
      case $::operatingsystem {
        'Gentoo': {
          package{ 'www-servers/nginx':
            ensure => $ensure
          }
        }
        default: {
          fail("The type nginx::package is not support on ${::operatingsystem} (os family: ${::osfamily}.")
        }
      }
    }
  }
}
