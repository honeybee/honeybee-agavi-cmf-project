# Class: converjon
#
#
class converjon(
  $version                                = '',
  $running_port                           = '',
  $running_instance_name                  = '',
  $running_instance_timeout               = '',
  $url_whitelist                          = '',
  $running_instance_access_log_format     = '',
  $test_server_enable                     = '',
  $cache_base_path                        = '',
  $process_limit                          = '',
  $process_timeout                        = '',
  $analysis_aio_name                      = '',
  $converter_padding_color                = '',
  $cropping_default_mode                  = '',
  $constrains_quality_min                 = '',
  $constrains_quality_max                 = '',
  $constrains_colors_min                  = '',
  $constrains_colors_max                  = '',
  $constrains_width_min                   = '',
  $constrains_width_max                   = '',
  $constrains_height_min                  = '',
  $constrains_height_max                  = '',
  $logging_error                          = '',
  $logging_debug                          = '',
  $logging_access                         = '',
  $auth_username                          = '',
  $auth_password                          = '',
  $download_timeout                       = '',
  $reject_invalid_ssl                     = '',
  $base_url_path                          = '',
  $nginx_deployment                       = '',
  $aliases                                = [],
  $alias_basepath                         = '',
  $enable_auth                            = false,
  $garbage_collector_enabled              = true,
  $garbage_collector_source               = 'cache',
  $garbage_collector_target               = 'immediate',
  $garbage_collector_interval             = 5000
)
{
  require converjon::nodejs
  require converjon::install
  require converjon::aliases
  require converjon::nginx
}
