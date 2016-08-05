# Class: berlinonline:sudos deploys sudo configs
#
class berlinonline::sudos(
  $all              = ['deploy'],
  $aliases          = [],
  $users            = [],
  ){
  class { 'sudo':
    ensure => present
  }
  #deploy users that are allowed to do everything
  $::berlinonline::sudos::all.each |$all_user| {
    sudo::directive {$all_user :
      content => "${all_user} ALL=(ALL) NOPASSWD:ALL\n",
      user    => $all_user
    }
  }
  #deploy sudo aliases
  $::berlinonline::sudos::aliases.each |$alias|{
    sudo::alias::command{ "alias_${alias[name]}":
      cmdlist => $alias[commands]
    }
  }

  $indexes = []
  $::berlinonline::sudos::users.each |$user| {
    $indexes = values($user)
    $user_hash = $indexes[0]
    sudo::directive {"${user_hash[name]}_commands" :
      content  => "${user_hash[name]} ALL=(ALL) NOPASSWD: ",
      commands => $user_hash[commands],
      mode     => 'array',
      user     => $user_hash[name]
    }
  }
}
