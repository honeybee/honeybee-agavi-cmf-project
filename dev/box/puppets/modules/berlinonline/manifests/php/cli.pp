# Class: cli
#
#
class berlinonline::php::cli
{
  case $::operatingsystem {
    'debian': {
      require berlinonline::php::cli::debian
    }
    'OpenSuSE': {
      require berlinonline::php::cli::opensuse
    }
    default: {
      alert { "Operatingsystem ${::operatingsystem} does not seem to be supported" :}
    }
  }
}
