# Class: cli
#
#
class php::modules::cli
{
  case $::operatingsystem {
    'debian': {
      require php::modules::cli::debian
    }
    'OpenSuSE': {
      require php::modules::cli::opensuse
    }
    default: {
      alert { "Operatingsystem ${::operatingsystem} does not seem to be supported" :}
    }
  }
}
