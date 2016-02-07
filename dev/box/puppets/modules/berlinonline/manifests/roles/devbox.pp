# Class: berlinonline::roles::devbox
#
#
class berlinonline::roles::devbox {
  require basics::packages
  realize Package[vim]
  realize Package[avahi]
  realize Package[nfs_server]
  realize Package[php5-xdebug]

  service { 'avahi-daemon':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Package['avahi']
  }
  service { 'nfsserver':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Package['nfs_server']
  }
  
  #since there is no out-of-the-box working nfs module that works for opensuse and the future parser we wil do it ourself here
  file { '/etc/exports':
    ensure  => file,
    content => template('berlinonline/devbox_exports.erb'),
    notify  => Service['nfsserver'],
    require => Package['nfs_server']
  }
  #
  user { 'vagrant':
    ensure => present,
    home   => '/home/vagrant',
    groups => ['deploy']
  }
  
  user { 'wwwrun':
    ensure => present,
    groups => ['deploy', 'users'],
  }


}
