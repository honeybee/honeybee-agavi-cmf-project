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
  $download_timeout                       = '',
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
)
{
  define alias (String $base_file_path, Array $headers = [], Array $fallback_base_file_paths = []) {
    file { "${converjon::alias_basepath}/$name.yml":
      ensure  => file,
      content => template('converjon/alias.erb')
    }
  }
  require converjon::npm
  require converjon::install
  require converjon::aliases
  require converjon::nginx
}
