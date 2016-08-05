#class nginx::service
#
#ensure that service is running (or not running) as desired
class nginx::service (
){
  #deploy possible custom start/stop scripts for nginx
  case $::operatingsystem {
    'OpenSuSE': {
      file { '/etc/systemd/system/nginx.service':
        ensure  => present,
        content => template('berlinonline/nginx.service.erb'),
        require => Package['nginx'],
        notify  => Service['nginx']
      }
    }
    default : {
      notice { 'Using default service script for nginx' :}
    }
  }
  service { 'nginx':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true
  }
}
