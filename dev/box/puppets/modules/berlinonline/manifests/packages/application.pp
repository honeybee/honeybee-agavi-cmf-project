# Class: berlinonline::packages::application
#
#deploys packages needed for Honeybee
class berlinonline::packages::application {
  case $::operatingsystem {
    'openSuSE': {
      zypprepo { 'mruediger_php_work':
          baseurl      =>"http://download.opensuse.org/repositories/home:/loosi:/work:/php/openSUSE_${::operatingsystemrelease}/",
          enabled      => 1,
          autorefresh  => 1,
          name         => 'openSUSE_13.2_php_mruediger',
          gpgcheck     => 0,
          priority     => 98,
          keeppackages => 1,
          type         => 'rpm-md',
      }
      package { 'php5-pecl-zmq':
        ensure  => installed,
        notify  => Service['php-fpm'],
        require => Zypprepo['mruediger_php_work'],
      }

      package { 'php5-pecl-ev':
        ensure  => installed,
        notify  => Service['php-fpm'],
        require => Zypprepo['mruediger_php_work'],
      }
    }
    default: {
      alert { "Operatingsystem ${::operatingsystem} does not seem to be supported" :}
    }
  }

}
