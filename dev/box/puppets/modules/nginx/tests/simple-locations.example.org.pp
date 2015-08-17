$domain_name = "simple-locations.example.org"
$server_config_file_name = "/tmp/pp-nginx-results/$domain_name.conf"

nginx::server { $domain_name:
  ensure => present,
  server_config_file_name => $server_config_file_name,
  content => "
    listen                *:80;

    server_name           $domain_name;
  "
}

nginx::server::location { "everything":
  location => "~ .*",
  server => Nginx::Server[$domain_name],
  order => 52,
  content => "
        root /var/www/$domain_name;
"
}

