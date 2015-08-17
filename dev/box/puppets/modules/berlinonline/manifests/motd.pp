# Class: berlinonline::motd
#
#
class berlinonline::motd{
  $motd_tail = '/etc/motd.tail'
  #manages BerlinOnline motd with either motd.tail or motd itself
  #this only exists on ubuntu
  if $::operatingsystem == 'Ubuntu' {
    file { '/etc/update-motd.d/10-help-text':
      ensure => absent,
    }
    file { '/etc/update-motd.d/95-monit-summary':
      ensure  => file,
      content => '#!/bin/sh
/usr/bin/monit summary'
    }
  }
  file { '/etc/motd':
    ensure  => file,
    content => template("berlinonline/motd/${::operatingsystem}.erb"),
  }

}
