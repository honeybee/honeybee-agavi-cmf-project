# class converjon::npm
#
#
class converjon::npm {
  if $::operatingsystemrelease == '13.2' {
    zypprepo { "OpenSuse_${operatingsystemrelease}_mruediger_stable":
          baseurl      => "http://download.opensuse.org/repositories/home:/loosi:/work/openSUSE_${::operatingsystemrelease}",
          enabled      => 1,
          autorefresh  => 1,
          name         => "OpenSuse_${::operatingsystemrelease}_mruediger_stable",
          gpgcheck     => 0,
          priority     => 98,
          keeppackages => 1,
          type         => 'rpm-md',
          before       => Exec['zypper-refresh']
    }
    ->
    package { 'nodejs':
      ensure => installed,
    }
  }

}
