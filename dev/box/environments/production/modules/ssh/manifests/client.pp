#Class ssh::client
# deploys client ssh config
class ssh::client(
  $source = undef,
)
{
  file { $::ssh::params::ssh_config:
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('ssh/server/ssh_config.erb'),
  }
}