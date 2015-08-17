$domain_name = "auth-basic-location.example.org"
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
  location => "~ /assets/",
  server => Nginx::Server[$domain_name],
  content => "
        index index.html;
"
}

nginx::server::location::auth-basic { "auth-basic-with-content":
  location => Nginx::Server::Location["with-content"],
  text => 'This is restricted',
  user_file => '/dev/null'
}

nginx::server::location { "without-content":
  location => "~ /other-assets/",
  server => Nginx::Server[$domain_name],
}

nginx::server::location::auth-basic { "auth-basic-without-content":
  location => Nginx::Server::Location["without-content"],
  text => 'This is restricted',
  user_file => '/dev/null'
}
