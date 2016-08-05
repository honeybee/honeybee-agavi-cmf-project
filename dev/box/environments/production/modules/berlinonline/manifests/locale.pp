# Class: berlinonline::locale
#
#
class berlinonline::locale {
  require '::berlinonline'
  file { "${::berlinonline::locale_dir}/${::berlinonline::application_name}" :
    ensure => directory,
    owner  => $::berlinonline::scm_user,
    group  => $::berlinonline::scm_group_primary,
  }
}
