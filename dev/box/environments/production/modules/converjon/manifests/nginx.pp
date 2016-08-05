# Class: converjon::nginx
#
#
class converjon::nginx {
  # deployes nginx config for converjon
  #possible ways:
  # - deploy at subdomain
  # - deploy at path at fqdn
  case $converjon::nginx_deployment {
    'subdomain' : {
      notify { 'Setup currently not finished':}
    }
    'path' : {
      if $::converjon::base_url_path == '/' {
        fail('The base path is configured as /, you dont want to do that without a subdomain')
      }
      else {
        nginx::server::location { 'Converjon':
          location => $converjon::base_url_path,
          server   => Nginx::Server[$::berlinonline::application_name],
          order    => 15,
          content  => "
            proxy_pass http://127.0.0.1:${::converjon::running_port};
          "
        }
      }
    }
    'none' : {
      notify { 'Not deploying converjon nginx config' :}
    }
    default : {
      crit('Error, no converjon::nginx_deployment given')
    }
  }
}
