# Class: berlinonline::roldefines required resources for deploying apps
#
class berlinonline::roles::application {
  # defines required resources for deploying apps
  include ::berlinonline::locale
  include ::berlinonline::logrotate::application
  file { "${berlinonline::webdirectory}/${berlinonline::application_name}":
    ensure => directory,
    owner  => $berlinonline::scm_user,
    group  => $berlinonline::scm_user,
    mode   => $berlinonline::webdir_application_mode,
  }
  ->
  file { "${::berlinonline::locale_dir}/${::berlinonline::application_name}/environment" :
    ensure  => file,
    content => $::berlinonline::application_env,
    require => File["${::berlinonline::locale_dir}/${::berlinonline::application_name}"]
  }

  include berlinonline::fpm::application
  include berlinonline::packages::application
  include berlinonline::nginx::application
}