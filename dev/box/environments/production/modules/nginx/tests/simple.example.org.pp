nginx::server { "simple.example.org":
  ensure => present,
  server_config_file_name => "/tmp/pp-nginx-results/simple.example.org.conf",
  content => "
    listen                *:80;

    server_name           simple.example.org;

    access_log            /var/log/nginx/simple.example.org.access.log;
    error_log             /var/log/nginx/simple.example.org.error.log;
  "
}
