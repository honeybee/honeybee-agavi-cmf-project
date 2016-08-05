define nginx::server (
  $ensure = present,
  $server_config_header_template = 'nginx/conf.d/server_header.conf.erb',
  $server_config_footer_template = 'nginx/conf.d/server_footer.conf.erb',
  $server_config_file_name = "/etc/nginx/vhosts.d/${name}.conf",
  $server_config_owner = 'root',
  $server_config_group = 'root',
  $server_config_mode = '0644',
  $content = ''
  ) {
  include nginx::base

  if $ensure == present {
    concat { $server_config_file_name:
    owner => $server_config_owner,
    group => $server_config_group,
    mode  => $server_config_mode,
    order => 'alpha',
  }

  if defined(Service['nginx']) {
    Concat[ $server_config_file_name] {
      notify => Service['nginx']
    }
  }

  concat::fragment{ "${server_config_file_name}_header":
  target  => $server_config_file_name,
  content => template($server_config_header_template),
  order   => '001+'
}

  concat::fragment{ "${server_config_file_name}_footer":
  target  => $server_config_file_name,
  content => template($server_config_footer_template),
  order   => '999+'
  }
  }
  else {
    file { $server_config_file_name:
    ensure => absent
    }
  }
}
