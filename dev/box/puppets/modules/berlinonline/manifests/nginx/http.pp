# Class: berlinonline::nginx::http
#
#
class berlinonline::nginx::http{
  nginx::server { $::berlinonline::application_name:
    content => "
      listen 80;
      listen [::]:80 ipv6only=on;
      server_name           ${$::berlinonline::application_name};
      access_log            /var/log/nginx/application-${::berlinonline::application_name}_access.log;
      error_log             /var/log/nginx/application-${::berlinonline::application_name}_error.log;
      root                  ${::berlinonline::webdirectory}/${$::berlinonline::application_name}/${$::berlinonline::application_dir}/;
      client_max_body_size  ${::php::fpm_post_max_size};
      try_files             \$uri @rewrite;
    "
  }
  if $berlinonline::application_server_name {
    $server_name = $berlinonline::application_server_name
  }
  else {
    $server_name = $berlinonline::application_name
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
