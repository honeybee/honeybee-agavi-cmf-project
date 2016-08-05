# Class: basics:users deploys general users for servers
#
class basics::users{
  require berlinonline
  user { $::berlinonline::scm_user :
    ensure     => present,
    home       => "/home/${$::berlinonline::scm_user}",
    shell      => '/bin/bash',
    groups     => hiera_array(berlinonline::scm_groups),
    #uid        => 1001,
    require    => Group[$::berlinonline::scm_groups],
    managehome => true,
  }
  group { $::berlinonline::scm_group_primary :
    ensure => present,
    gid    => 10001
  }
  user { 'root':
    ensure => present
  }
  file { "/home/${$::berlinonline::scm_user}/.local" :
    ensure  => directory,
    owner   => $::berlinonline::scm_user,
    group   => $::berlinonline::scm_group_primary,
    require => User[$::berlinonline::scm_user]
  }
}
