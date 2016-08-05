# File::      <tt>host.pp</tt>
# Author::    Sebastien Varrette (<Sebastien.Varrette@uni.lu>)
# Copyright:: Copyright (c) 2014 Sebastien Varrette (www[http://varrette.gforge.uni.lu])
# License::   GPLv3
#
# ------------------------------------------------------------------------------
# Execute this manifest in your vagrant box as follows
#
#   sudo puppet apply -t /vagrant/tests/alias/host.pp --noop
#

class { 'sudo':
    configfile => '/tmp/sudoers'
}

sudo::alias::host{ 'SERVERS':
  hostlist => [ '192.168.0.1', '192.168.0.2' ],
  comment  => 'This is all the servers'
}
sudo::alias::host{ 'NETWORK':
  hostlist => [ '192.168.0.0/255.255.255.0' ]
}
sudo::alias::host{ 'WORKSTATIONS':
  hostlist => [ 'NETWORK', '!SERVER' ],
  comment  => 'This is every machine in the network that is not a server'
}

