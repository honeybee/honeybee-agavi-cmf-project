# Class: berlinonline::nginx::cms
#
#
class berlinonline::nginx::cms{
  require ::nginx
  require ::php

  file { '/etc/berlinonline':
    ensure => directory,
  }->
  file { "/etc/berlinonline/ssl_${berlinonline::cms_name}_template.cnf":
    ensure  => file,
    content => template('berlinonline/ssl/template.cnf.erb'),
  }
  ->ssl_pkey { "/etc/nginx/ssl/${berlinonline::cms_name}.pem":
    ensure => 'present',
    notify => Service[$::php::fpm_service_name]
  }
  ->x509_cert { "/etc/nginx/ssl/${berlinonline::cms_name}.crt":
    ensure      => 'present',
    private_key => "/etc/nginx/ssl/${berlinonline::cms_name}.pem",
    days        => 365,
    force       => false,
    template    => "/etc/berlinonline/ssl_${berlinonline::cms_name}_template.cnf",
    notify      => Service[$::php::fpm_service_name]
  }
  ->
  nginx::server { $berlinonline::cms_name:
    content => "
      listen 443 ssl;
      listen [::]:443 ssl ipv6only=on;
      server_name           ${$berlinonline::cms_name};
      access_log            /var/log/nginx/cms-${berlinonline::cms_name}_access.log;
      error_log             /var/log/nginx/cms-${berlinonline::cms_name}_error.log;
      root                  ${berlinonline::webdirectory}/${$berlinonline::cms_name}/${$berlinonline::cms_dir}/;
      client_max_body_size  ${::php::fpm_post_max_size};
      ssl_certificate       /etc/nginx/ssl/${$berlinonline::cms_name}.crt;
      ssl_certificate_key   /etc/nginx/ssl/${$berlinonline::cms_name}.pem;
      try_files             \$uri @rewrite;
    "
  }

  nginx::server::location { "${::berlinonline::cms_name}_rewrite":
    location => '@rewrite',
    content  => 'rewrite ^/([^?]*)$ /index.php?/$1 last;',
    server   => Nginx::Server[$berlinonline::cms_name],
    order    => 50
  }

  nginx::server::location { $berlinonline::cms_name:
    location => '~ \.php($|/|\?)',
    server => Nginx::Server[$berlinonline::cms_name],
    order => 20,
    content => "
      fastcgi_pass    unix:/var/run/php-fpm/${berlinonline::cms_name}.sock;
      include         conf.d/fastcgi_params_${berlinonline::cms_name};
      fastcgi_param   SCRIPT_FILENAME   \$document_root\$fastcgi_script_name;
      fastcgi_param   PATH_INFO         \$fastcgi_script_name;
      fastcgi_param   SERVER_NAME       ${berlinonline::cms_name};
      fastcgi_param   SERVER_PORT       443;
      fastcgi_param   HTTPS             on;
    "
  }
  ->
  file {"/etc/nginx/conf.d/fastcgi_params_${berlinonline::cms_name}":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('nginx/conf.d/fastcgi_params.erb'),
    notify  => Service[nginx]
  }
}
