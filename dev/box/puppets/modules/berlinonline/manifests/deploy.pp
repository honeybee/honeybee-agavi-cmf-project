# right now this modules deploys a single application (like berlinonline module). In future release we may be provide resources to
# deploy multiple apps per server.
# Class: berlinonline::deploy
#
#
class berlinonline::deploy {

  exec { 'ssh know github':
    command => 'ssh -Tv git@github.com -o StrictHostKeyChecking=no; echo Success',
    path    => '/bin:/usr/bin',
    user    => 'deploy'
  }
  exec { 'ssh know gitlab':
    command => 'ssh -Tv git@gitlab.berlinonline.net -p 722 -o StrictHostKeyChecking=no; echo Success',
    path    => '/bin:/usr/bin',
    user    => 'deploy',
    require => Exec['ssh know github']
  }

  unless empty($berlinonline::project_git_path) {
    vcsrepo { "${berlinonline::webdirectory}/${berlinonline::application_name}":
      ensure   => present,
      provider => git,
      source   => $berlinonline::project_git_path,
      user     => 'deploy',
      owner    => 'deploy',
      group    => 'deploy',
      require  => Exec['ssh know gitlab']
    }
  }

  # exec { 'deploy_cms_init_script':
  #   command     => "${berlinonline::webdirectory}/${berlinonline::cms_name}/${berlinonline::deploy_script}",
  #   refreshonly => true,
  #   require     => Vcsrepo["${berlinonline::webdirectory}/${berlinonline::cms_name}"]
  # }
}
