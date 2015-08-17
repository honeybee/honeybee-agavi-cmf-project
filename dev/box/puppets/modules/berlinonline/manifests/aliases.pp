class berlinonline::aliases {
  file { '/etc/aliases' :
      mode  => '0644',
      owner => 'root',
      group => 'root',
  }
  #this makes it possible to override the root_recipient for message with a given fact from vagrant for devboxes
  if !validate_slength($::aliases_root_recipient,1){
    $root_recipient = $berlinonline::aliases_root_recipient
  }
  else {
    $root_recipient = $::aliases_root_recipient
  }
  mailalias { 'root':
    name      => 'root',
    recipient => $root_recipient,
    notify    => Exec['newaliases'],
  }

  exec { 'newaliases':
      command     => '/usr/bin/newaliases',
      refreshonly => true,
      subscribe   => File['/etc/aliases'],
    }
}
