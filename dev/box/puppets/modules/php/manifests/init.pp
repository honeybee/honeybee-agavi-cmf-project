# Class: php
#
#
class php(
  $post_max_size              =   0,
  $upload_max_filesize        =   0,
  $log_errors_max_len         =   0,
  $max_file_uploads           =   0,
  $fpm_post_max_size          =   '17M',
  $fpm_upload_max_filesize    =   '16M',
  $fpm_log_errors_max_len     =   '4096',
  $fpm_max_file_uploads       =   '30',
  $cli_post_max_size          =   '17M',
  $cli_upload_max_filesize    =   '16M',
  $cli_log_errors_max_len     =   '4096',
  $cli_max_file_uploads       =   '30',
  $fpm_service_name           =   '',
  $fpm_package_name           =   'php5-fpm',
)
{
  require ::berlinonline
  case $::operatingsystem {
    'OpenSuSE' : {
      zypprepo { 'OpenSuse_PHP_Extension':
        baseurl      => "http://download.opensuse.org/repositories/server:/php:/extensions/openSUSE_${operatingsystemrelease}/",
        enabled      => 1,
        autorefresh  => 1,
        name         => 'OpenSuse_PHP_Extension',
        gpgcheck     => 0,
        priority     => 98,
        keeppackages => 1,
        type         => 'rpm-md',
        notify       => Exec['zypper-refresh'],
        before       => Package[php5-imagick]
      }
      realize Package[php5-imagick]
    }
    'Ubuntu' : {
      case ::operatingsystemrelease {
        '12.04' : {
          file { '/etc/init.d/php5-fpm':
            ensure  => present,
            content => template('php/fpm_init.erb'),
            mode    => '0755',
            notify  => Service['nginx']
          }
        }
        default : {}
      }
      realize Package[php5-imagick]
    }
    default : {
      notify {'No Package for php5-imagick given for your OS' :}
    }
  }


  file { '/var/log/php':
    ensure  => 'directory',
    owner   => $berlinonline::scm_user,
    group   => $berlinonline::scm_user,
    mode    => '0744',
    require => User[$berlinonline::scm_user],
  }

  realize Package[php5-openssl]
  realize Package[php5-intl]
  realize Package[php5-gd]
  realize Package[php5-xsl]
  realize Package[php5-curl]
  realize Package[php5-json]
  realize Package[php5-tokenizer]
  realize Package[php5-iconv]
  realize Package[php5-phar]
  realize Package[php5-xmlwriter]
  

}
