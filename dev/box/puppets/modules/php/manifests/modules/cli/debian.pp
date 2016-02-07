# Class: php::modules::cli::debian
#
#deploy php-cli packages and config for debian systems
class php::modules::cli::debian {
  package { 'php5-cli':
    ensure => latest,
  }
  file {
    '/etc/php5/cli/php.ini':
    ensure  => present,
    content => template('php/php-cli.ini.erb'),
    require => Package['php5-cli'];
  }
}
