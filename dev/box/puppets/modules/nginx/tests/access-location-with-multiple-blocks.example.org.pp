#
# This is an example with multiple blocks
#
# location ~ /fives/ {
#   deny    192.168.1.1;
#   allow   192.168.1.0/24;
#   allow   10.1.1.0/16;
#   allow   2620:100:e000::8001;
#   deny    all;
# }

$domain_name = "access-location-with-multiple-blocks.example.org"
$server_config_file_name = "/tmp/pp-nginx-results/$domain_name.conf"

nginx::server { $domain_name:
  ensure => present,
  server_config_file_name => $server_config_file_name,
  content => "
    listen                *:80;

    server_name           $domain_name;
  "
}

nginx::server::location { "with-multiple-blocks":
  location => "~ /fives/",
  server => Nginx::Server[$domain_name],
}

nginx::server::location::access { "block-one-with-multiple-blocks":
  location => Nginx::Server::Location["with-multiple-blocks"],
  deny => ['192.168.1.1']
}

nginx::server::location::access { "block-two-with-multiple-blocks":
  location => Nginx::Server::Location["with-multiple-blocks"],
  allow => ['192.168.1.0/24', '10.1.1.0/16', '2620:100:e000::8001'],
  deny => ['all']
}