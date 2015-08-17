# Class: berlinonline::roldefines required resources for deploying apps
#
class berlinonline::roles::cms {
  # defines required resources for deploying apps
  file { "${berlinonline::webdirectory}/${berlinonline::cms_name}":
    ensure => directory,
    owner  => $berlinonline::scm_user,
    group  => $berlinonline::scm_user,
    mode   => $berlinonline::webdir_cms_mode,
  }
  ->
  #since there is no clean way to add a file with conditions in puppet we use the exec way
  exec {'create_cms_env_file':
    command => "/bin/echo \'${berlinonline::bo_environment}\' > ${berlinonline::webdirectory}/${berlinonline::cms_name}/.environment",
    onlyif  => "/usr/bin/test -d ${berlinonline::webdirectory}/${berlinonline::cms_name}/.git",
  }

  include berlinonline::fpm::cms
  include berlinonline::packages::cms
  include berlinonline::nginx::cms
}
