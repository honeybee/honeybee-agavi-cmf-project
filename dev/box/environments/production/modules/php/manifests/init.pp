# Class: php
#
#
class php(
  $fpm_post_max_size          =   '17M',
  $fpm_upload_max_filesize    =   '16M',
  $fpm_log_errors_max_len     =   '8192',
  $fpm_max_file_uploads       =   '90',
  $fpm_max_input_vars         =   3000,
  $cli_post_max_size          =   '17M',
  $cli_upload_max_filesize    =   '16M',
  $cli_log_errors_max_len     =   '8192',
  $cli_max_file_uploads       =   '90',
  $cli_max_input_vars         =   3000,
  $fpm_service_name           =   'php-fpm',
  $fpm_package_name           =   'php5-fpm',
  $opcache_enable             =   1,
  $opcache_enable_cli         =   1,
  $opcache_memory             =   128,
  $opcache_strings_buffer     =   16,
  $opcache_max_files          =   20000,
  $opcache_max_wasted         =   10,
  $opcache_validate_time      =   1,
  $opcache_revalidate_freq    =   60,
  $opcache_use_cwd            =   1,
  $opcache_fast_shutdown      =   0,
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

      # packages necessary for OpenSUSE (that are built-in in Ubuntu's php packages)
      realize Package[php5-bcmath]
      realize Package[php5-ctype]
      realize Package[php5-fileinfo]
      realize Package[php5-iconv]
      realize Package[php5-mbstring]
      realize Package[php5-opcache]
      realize Package[php5-openssl]
      realize Package[php5-pcntl]
      realize Package[php5-phar]
      realize Package[php5-sockets]
      realize Package[php5-tokenizer]
      realize Package[php5-xmlwriter]
      realize Package[php5-zip]
      realize Package[php5-zlib]
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

  # packages available in Ubuntu and OpenSUSE
  realize Package[php5-curl]
  realize Package[php5-gd]
  realize Package[php5-intl]
  realize Package[php5-json]
  realize Package[php5-mcrypt]
  realize Package[php5-xsl]

}
