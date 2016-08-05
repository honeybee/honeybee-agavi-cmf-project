# Class: basics
#
#
class basics
{
  # basic software our box should have
  file { $::berlinonline::webdirectory:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => $::berlinonline::webdirectory_mode,
  }
}
