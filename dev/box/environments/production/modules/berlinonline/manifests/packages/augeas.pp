# Class: berlinonline::packages::augeas
#
#deploys packages and repos needed for augeas
class berlinonline::packages::augeas {
  case $::operatingsystem {
    'openSuSE': {
      zypprepo { 'opensuse_puppet':
          baseurl      =>"http://download.opensuse.org/repositories/systemsmanagement:/puppet/openSUSE_${::operatingsystemrelease}/",
          enabled      => 1,
          autorefresh  => 1,
          name         => "openSUSE_${::operatingsystemrelease}_puppet",
          gpgcheck     => 0,
          priority     => 97,
          keeppackages => 1,
          type         => 'rpm-md',
          before       => Exec['zypper-refresh']
      }
      if ($::rubyversion > '2.1.0') and ($::rubyversion <'2.2.0') {
        package { 'ruby2.1-rubygem-ruby-augeas':
          ensure  => installed,
          require => Zypprepo['opensuse_puppet'],
        }
      }
      package { 'augeas-lenses' :
        ensure => installed
      }
    }
    default: {
      fail ('Augeas currently supported on opensuse only')
    }
  }
}
