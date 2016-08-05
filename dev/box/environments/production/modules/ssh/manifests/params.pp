#class ssh::params
class ssh::params {

  case $::operatingsystem {
    'Ubuntu': {
      $server_package_name = 'openssh-server'
      $client_package_name = 'openssh-client'
      $sshd_config         = '/etc/ssh/sshd_config'
      $ssh_config          = '/etc/ssh/ssh_config'
      $ssh_known_hosts     = '/etc/ssh/ssh_known_hosts'
      $service_name        = 'ssh'
    }
    default: {
      case $::osfamily {
        'debian': {
          $server_package_name = 'openssh-server'
          $client_package_name = 'openssh-client'
          $sshd_config         = '/etc/ssh/sshd_config'
          $ssh_config          = '/etc/ssh/ssh_config'
          $ssh_known_hosts     = '/etc/ssh/ssh_known_hosts'
          $service_name        = 'ssh'
        }
        'redhat': {
          $server_package_name = 'openssh-server'
          $client_package_name = 'openssh-clients'
          $sshd_config         = '/etc/ssh/sshd_config'
          $ssh_config          = '/etc/ssh/ssh_config'
          $ssh_known_hosts     = '/etc/ssh/ssh_known_hosts'
          $service_name        = 'sshd'
        }
        'Suse': {
          $server_package_name = 'openssh'
          $client_package_name = 'openssh'
          $sshd_config         = '/etc/ssh/sshd_config'
          $ssh_config          = '/etc/ssh/ssh_config'
          $ssh_known_hosts     = '/etc/ssh/ssh_known_hosts'
          $service_name        = 'sshd'
        }
        default: {
          fail("Unsupported platform in module ${module_name}: ${::osfamily}/${::operatingsystem}")
        }
      }
    }
  }

}
