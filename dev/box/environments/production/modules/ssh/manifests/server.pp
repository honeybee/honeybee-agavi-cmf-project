#Class ssh::server
#deploys ssh server config
class ssh::server(
  $ensure = 'running',
  $source = undef,
  $sshd_port   = 22,
)
{

  require ssh::params
  if $ensure in [ running, stopped ] {
    $ensure_real = $ensure
  } else {
    fail('Ensure parameter for class ssh::server must be "running" or "stopped". Default is "running".')
  }

  if $source == undef {
    notice('No source parameter specified for ssh::server class. Using defaults.')
    $source_real = [
      "puppet:///modules/${module_name}/${hostname}/sshd_config",
      "puppet:///modules/${module_name}/server/sshd_config",
      'puppet:///modules/ssh/server/sshd_config',
      'puppet:///modules/ssh/sshd_config',

      # TODO add something more sophisticated for puppet master setups?
      #"puppet:///modules/${caller_module_name}/sshd_config", # probably only useful if we create a define
      #"puppet:///modules/${module_name}/server/sshd_config",
      #"puppet://$server/private/$domain/$module_name/$os/$osver/sshd_config.$hostname",
      #"puppet://$server/private/$domain/$module_name/$os/$osver/sshd_config",
      #"puppet://$server/private/$domain/$module_name/$os/sshd_config.$hostname",
      #"puppet://$server/private/$domain/$module_name/$os/sshd_config",
      #"puppet://$server/private/$domain/$module_name/sshd_config.$hostname",
      #"puppet://$server/private/$domain/$module_name/sshd_config",
      #"puppet://$server/files/$module_name/$os/$osver/sshd_config.$hostname",
      #"puppet://$server/files/$module_name/$os/$osver/sshd_config",
      #"puppet://$server/files/$module_name/$os/sshd_config.$hostname",
      #"puppet://$server/files/$module_name/$os/sshd_config",
      #"puppet://$server/files/$module_name/sshd_config.$hostname",
      #"puppet://$server/files/$module_name/sshd_config",
      #"puppet://$server/$module_name/$os/$osver/sshd_config",
      #"puppet://$server/$module_name/$os/sshd_config",
      #"puppet://$server/$module_name/sshd_config"
    ]
  }
  else {
    notice('Using given custom source parameter for ssh::server class.')
    $source_real = $source
  }

  package { $ssh::params::server_package_name :
    ensure => present,
  }

  service { $ssh::params::service_name :
    ensure     => $ensure_real,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => File[$ssh::params::sshd_config ],
  }

  file { $ssh::params::sshd_config :
    ensure       => present,
    mode         => '0644',
    owner        => 'root',
    group        => 'root',
    content      => template('ssh/server/sshd_config.erb'),
    sourceselect => first,
    require      => Package[$ssh::params::server_package_name],
    notify       => Service[ $ssh::params::service_name],
  }
}
