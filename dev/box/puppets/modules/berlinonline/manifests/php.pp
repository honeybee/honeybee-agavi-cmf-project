# Class: berlinonline::php
#
#
class berlinonline::php{
  case $::operatingsystem {
    'OpenSuSE' : {
      zypprepo { 'OpenSuse_PHP_Extension':
        baseurl      => "http://download.opensuse.org/repositories/server:/php:/extensions/openSUSE_${operatingsystemrelease}/",
        enabled      => 1,
        autorefresh  => 1,
        name         => 'OpenSuse_PHP_Extension',
        gpgcheck     => 0,
        priority     => 98,
        keeppackages => 1,
        type         => 'rpm-md',
        notify       => Exec['zypper-refresh'],
        before       => Package[php5-imagick]
      }
      realize Package[php5-imagick]
    }
    'Ubuntu' : {
      case ::operatingsystemrelease {
        '12.04' : {
          file { '/etc/init.d/php5-fpm':
            ensure  => present,
            content => template('php/fpm_init.erb'),
            mode    => '0755',
            notify  => Service['nginx']
          }
        }
      }
      realize Package[php5-imagick]
    }
    default : {
      notify {'No Package for php5-imagick given for your OS' :}
    }
  }


  file { '/var/log/php':
    ensure  => 'directory',
    owner   => $berlinonline::scm_user,
    group   => $berlinonline::scm_user,
    mode    => '0744',
    require => User[$berlinonline::scm_user],
  }

}
