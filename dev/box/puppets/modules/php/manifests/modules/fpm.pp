# Class: php::modules::fpm
#
#
class php::modules::fpm
{
  class { 'phpfpm':
    poold_purge => true,
  }
  phpfpm::pool { 'default':
    ensure => 'absent',
  }
  phpfpm::pool { 'www':
    ensure => 'absent',
  }

  file { '/var/log/php-fpm':
    ensure => directory,
    owner  => $berlinonline::webuser,
    before => Service['php-fpm']
  }
  file { '/var/run/php-fpm':
    ensure => directory,
    owner  => $berlinonline::webuser,
    before => Service['php-fpm']
  }

  case $::operatingsystem {
    'debian': {
      require php::modules::fpm::debian
    }
    'OpenSuSE': {
      require php::modules::fpm::opensuse
    }
    default: {
      alert { "Operatingsystem ${::operatingsystem} does not seem to be supported" :}
    }
  }

  file {
    '/etc/php5/fpm/php.ini':
    ensure  => present,
    content => template('php/php-fpm.ini.erb'),
    require => Package[$php::fpm_package_name]
  }
  case $::operatingsystem {
    'OpenSuSE': {
      require php::modules::fpm::opensuse
    }
    default: {
      alert { "Operatingsystem ${::operatingsystem} does not seem to be supported" :}
    }
  }
}
