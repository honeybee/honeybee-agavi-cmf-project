# Class: berlinonline::packages::cms packages needed for cms boxes
#
#deploys packages needed for Honeybee CMS
class berlinonline::packages::cms {
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
  
  package { 'php5-mcrypt':
    ensure => installed,
    notify => Service['php-fpm']
  }

  package { 'php5-mbstring':
    ensure => installed,
    notify => Service['php-fpm']
  }

  package { 'php5-bcmath':
    ensure => installed,
    notify => Service['php-fpm']
  }

  package { 'php5-sockets':
    ensure => installed,
    notify => Service['php-fpm']
  }
  realize Package[php5-zip]
  realize Package[php5-zlib]
  realize Package[php5-fileinfo]
  realize Package[php5-ctype]

  

}
