class berlinonline::fpm::cms
{
  require ::php::modules::fpm

  if !defined(Class['::berlinonline::app_only']) {
    phpfpm::pool { $berlinonline::cms_name:
      listen                  => "/var/run/php-fpm/${$berlinonline::cms_name}.sock",
      user                    => $berlinonline::scm_user,
      group                   => $berlinonline::scm_user,
      listen_owner            => $berlinonline::webuser,
      listen_group            => $berlinonline::webgroup,
      pm                      => 'dynamic',
      pm_max_children         => 4,
      pm_start_servers        => 2,
      pm_min_spare_servers    => 1,
      pm_max_spare_servers    => 4,
      pm_max_requests         => 500,
      php_admin_flag          => {
        'expose_php' => 'Off',
      },
      php_admin_value         => {
        'max_execution_time' => '300',
      },
      slowlog                 => $berlinonline::cms_php_slowlog_path,
      request_slowlog_timeout => $berlinonline::cms_php_slowlog_time
    }
  }
}
