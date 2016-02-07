# Class: berlinonline::update
#
#
class berlinonline::update {
  #depending on host system we will make apt update and upgrade / zypper ref and zypper up
  case $berlinonline::repo_tool {
    'apt' : {
      require ::apt
      exec { 'apt-update':
          command => '/usr/bin/apt-get update'
      }
    }
    'zypp' : {
      exec { 'zypper-refresh':
        command     => 'zypper refresh',
        path        => ['/usr/bin', '/bin', '/sbin'],
        refreshonly => true
      }
    }
    default : {
      notify { 'There is no special package repo trigger defined for your OS' :}
    }
  }
}
