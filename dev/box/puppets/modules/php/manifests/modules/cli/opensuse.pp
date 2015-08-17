# Class: php::cli::opensuse
#
#
class php::modules::cli::opensuse {
  file {
    '/etc/php5/cli/php.ini':
    ensure  => present,
    content => template('php/php-cli.ini.erb'),
    require => Class[::php::modules::fpm]
  }
}

