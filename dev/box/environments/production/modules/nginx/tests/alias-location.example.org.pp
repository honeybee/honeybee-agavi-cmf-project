$domain_name = "alias-location.example.org"
$server_config_file_name = "/tmp/pp-nginx-results/$domain_name.conf"

nginx::server { $domain_name:
  ensure => present,
  server_config_file_name => $server_config_file_name,
  content => "
    listen                *:80;

    server_name           $domain_name;
  "
}

nginx::server::location { "with-content":
  location => "~ /assets/(.*)",
  server => Nginx::Server[$domain_name],
  content => "
        index index.html;
"
}

nginx::server::location::alias { "alias-with-content":
  location => Nginx::Server::Location["with-content"],
  directory => '/var/www/$domain_name/assets/$1',
}

nginx::server::location { "without-content":
  location => "~ /other-assets/(.*)",
  server => Nginx::Server[$domain_name],
}

nginx::server::location::alias { "alias-without-content":
  location => Nginx::Server::Location["without-content"],
  directory => '/var/www/$domain_name/assets/$1',
}
