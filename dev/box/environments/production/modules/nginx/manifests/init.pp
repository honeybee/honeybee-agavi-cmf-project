# Class: nginx
#
# # Basic Setup for standard nginx environment 
class nginx(
  ) {

  
  require nginx::package
  include ::nginx::service

  file{ '/etc/nginx/ssl':
    ensure  => directory,
    require => Package['nginx']
  }

  file{ '/etc/nginx/conf.d':
    ensure  => directory,
    require => Package['nginx']
  }
  
  file{ '/etc/nginx/vhosts.d':
    ensure  => directory,
    require => Package['nginx']
  }

  file {
    '/etc/nginx/nginx.conf':
    ensure  => file,
    content => template('nginx/nginx_conf.erb'),
    owner   => 'root',
    notify  => Service['nginx'],
    require => Package['nginx']
  }

  file { '/var/log/nginx' :
    ensure => directory,
    owner  => 'wwwrun',
    group  => 'deploy',
    mode   => '0640'
  }
}
