$domain_name = "access-location.example.org"
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
  location => "~ /first/",
  server => Nginx::Server[$domain_name],
  content => "
        index index.html;
"
}

nginx::server::location::access { "access-with-content":
  location => Nginx::Server::Location["with-content"],
  allow => ['all', '127.0.0.1'],
  deny => ['all', '127.0.0.1'],
}

nginx::server::location { "without-content":
  location => "~ /second/",
  server => Nginx::Server[$domain_name],
}

nginx::server::location::access { "access-without-content":
  location => Nginx::Server::Location["without-content"],
  allow => ['all', '127.0.0.1'],
  deny => ['all', '127.0.0.1'],
}

nginx::server::location { "without-deny":
  location => "~ /third/",
  server => Nginx::Server[$domain_name],
}

nginx::server::location::access { "access-without-deny":
  location => Nginx::Server::Location["without-deny"],
  allow => ['all', '127.0.0.1']
}

nginx::server::location { "without-allow":
  location => "~ /fourth/",
  server => Nginx::Server[$domain_name],
}

nginx::server::location::access { "access-without-allow":
  location => Nginx::Server::Location["without-allow"],
  deny => ['all', '127.0.0.1']
}