# Class: basics::packages
#
#
class basics::packages {
  require berlinonline

  if $::berlinonline::additional_packages {
    package {$::berlinonline::additional_packages :
      ensure => installed
    }
  }

  hiera_hash('berlinonline::packagelist').each |$package| {
    if has_key($package[1], 'ensure') {
      $ensure = $package[1][ensure]
    }
    else {
      $ensure = 'present'
    }

    if is_array($package[1][name]) {
      # we do have an alias for multiple packages, so use our own type defined for that
      @basics::multi_package { $package[0]:
        packagelist => $package[1][name],
      }
    }
    else {
      # seems a like a single package, lets go trough the possible options
      if $package[1][notify] and $package[1][require] {
        @package { $package[0]:
          ensure  => $ensure,
          name    => $package[1][name],
          require => $package[1][require],
          notify  => $package[1][notify]
        }
      }
      elsif $package[1][notify] and !$package[1][require] {
        @package { $package[0]:
          ensure => $ensure,
          name   => $package[1][name],
          notify => $package[1][notify]
        }
      }
      elsif !$package[1][notify] and $package[1][require] {
        @package { $package[0]:
          ensure  => $ensure,
          name    => $package[1][name],
          require => $package[1][require]
        }
      }
      else  {
        @package { $package[0]:
          ensure => $ensure,
          name   => $package[1][name],
        }
      }
    }
  }
}
