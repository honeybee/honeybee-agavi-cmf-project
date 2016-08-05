# Class: berlinonline::fpm::application
#
# fpm config for berlinonline default applications 
class berlinonline::fpm::application
{
  require ::php::modules::fpm
  include ::berlinonline::fpm
  include ::berlinonline::logrotate::php
  phpfpm::pool { $berlinonline::application_name:
    listen                  => "/var/run/php-fpm/${$berlinonline::application_name}.sock",
    user                    => $berlinonline::scm_user,
    group                   => $berlinonline::scm_user,
    listen_owner            => $berlinonline::webuser,
    listen_group            => $berlinonline::webgroup,
    pm                      => 'dynamic',
    pm_max_children         => $berlinonline::fpm::max_children,
    pm_start_servers        => $berlinonline::fpm::start_servers,
    pm_min_spare_servers    => $berlinonline::fpm::min_spare_server,
    pm_max_spare_servers    => $berlinonline::fpm::max_spare_server,
    pm_max_requests         => 500,
    php_admin_flag          => {
      'expose_php' => 'Off',
    },
    php_admin_value         => {
      'max_execution_time' => '300',
      'max_input_vars'     => $berlinonline::php_max_input_vars
    },
    slowlog                 => $berlinonline::application_php_slowlog_path,
    request_slowlog_timeout => $berlinonline::application_php_slowlog_time,
  }
}
