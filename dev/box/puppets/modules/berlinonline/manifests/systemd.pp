# Class: berlinonline::systemd
#
#
class berlinonline::systemd {
  #some systemd-specific stuff
  exec { 'systemctl-daemon-reload':
      command => '/usr/bin/systemctl daemon-reload',
    }
}
