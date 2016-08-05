# Class: berlinonline
#
# main entry point for berlinonline stuff
# variable definition only
class berlinonline(
  $project_name                         = '',
  $scm_user                             = 'deploy',
  $scm_group_primary                    = '',
  $scm_group_additional                 = [],
  $application_name                     = 'app-sample.stage.berlinonline.de',
  $application_dir                      = '/app',
  $application_php_slowlog_path         = '/var/log/php/app_slow.log',
  $application_php_slowlog_time         = '3s',
  $application_request_uri              = false,
  $application_https                    = false,
  $application_http_with_https          = false,
  $application_server_name              = false,
  $project_prefix                       = '',
  String $application_env               = '',
  $logrotage_app_path                   = 'applications/fe/pulq/app/log',
  $make_backup                          = false,
  $backup_setup                         = '',
  $use_own_cert                         = false,
  $warning_user                         = '',
  $webdirectory                         = '',
  $webdirectory_mode                    = '',
  $webuser                              = '',
  $webgroup                             = '',
  $bo_backup_name                       = '',
  $sync_failover_name                   = '',
  $sync_failover_port                   = '',
  $sync_user                            = '',
  $failover                             = '',
  $failover_cluster                     = '',
  $bo_environment                       = '',
  $repo_tool                            = '',
  $backup_host                          = '',
  $bo_backup_user                       = '',
  $webdir_application_mode              = '',
  $project_git_path                     = '',
  $additional_packages                  = undef,
  $required_packages                    = {},
  $packagelist                          = {},
  $sudos                                = {},
  $rabbit_user                          = 'bo',
  $rabbit_vhost                         = '/',
  $locale_dir                           = '/usr/local',
  $php_max_input_vars                   = 3000,
  )
{
  file { '/etc/berlinonline':
    ensure => directory,
  }
}
