# Class: php::modules::fpm::opensuse
#
#
class php::modules::fpm::opensuse {
  require ::php
  file {
    '/etc/systemd/system/php-fpm.service':
    ensure  => present,
    content => template('php/php-fpm.service.erb'),
    require => Package[$php::fpm_package_name],
    notify  => [Exec['systemctl-daemon-reload'], Service[$php::fpm_service_name]]
  }
}

