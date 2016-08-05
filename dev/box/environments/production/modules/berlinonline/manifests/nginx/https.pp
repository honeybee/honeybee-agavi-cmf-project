# Class: berlinonline::nginx::https
#
#
class berlinonline::nginx::https{
  if $berlinonline::application_server_name {
    $server_name = $berlinonline::application_server_name
  }
  else {
    $server_name = $berlinonline::application_name
  }

  file { "/etc/berlinonline/ssl_${::berlinonline::application_name}_template.cnf":
    ensure  => file,
    content => template('berlinonline/ssl/template.cnf.erb'),
  }
  ->
  ssl_pkey { "/etc/nginx/ssl/${::berlinonline::application_name}.pem":
    ensure  => 'present',
    notify  => Service[$::php::fpm_service_name],
    require => File['/etc/nginx/ssl'],
  }
  ->
  x509_cert { "/etc/nginx/ssl/${::berlinonline::application_name}.crt":
    ensure      => 'present',
    private_key => "/etc/nginx/ssl/${::berlinonline::application_name}.pem",
    days        => 365,
    force       => false,
    template    => "/etc/berlinonline/ssl_${::berlinonline::application_name}_template.cnf",
    notify      => Service[$::php::fpm_service_name],
    require     => File['/etc/nginx/ssl'],
  }
  ->
  nginx::server { $berlinonline::application_name:
    content => "
      listen 443 ssl;
      listen [::]:443 ssl ipv6only=on;
      server_name           ${$::berlinonline::application_name};
      access_log            /var/log/nginx/application-${::berlinonline::application_name}_access.log;
      error_log             /var/log/nginx/application-${::berlinonline::application_name}_error.log;
      root                  ${::berlinonline::webdirectory}/${$::berlinonline::application_name}/${$::berlinonline::application_dir}/;
      client_max_body_size  ${::php::fpm_post_max_size};
      ssl_certificate       /etc/nginx/ssl/${$::berlinonline::application_name}.crt;
      ssl_certificate_key   /etc/nginx/ssl/${$::berlinonline::application_name}.pem;
      try_files             \$uri @rewrite;
    "
  }
  nginx::server::location { "${::berlinonline::application_name}_rewrite":
    location => '@rewrite',
    content  => 'rewrite ^/([^?]*)$ /index.php?/$1 last;',
    server   => Nginx::Server[$::berlinonline::application_name],
    order    => 50
  }
  nginx::server::location { $::berlinonline::application_name:
    location => '~ \.php($|/|\?)',
    server   => Nginx::Server[$::berlinonline::application_name],
    order    => 20,
    content  => template('berlinonline/nginx/location_content.erb')
  }
  ->
  file {"/etc/nginx/conf.d/fastcgi_params_${::berlinonline::application_name}":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('nginx/conf.d/fastcgi_params.erb'),
    notify  => Service[nginx]
  }
}
