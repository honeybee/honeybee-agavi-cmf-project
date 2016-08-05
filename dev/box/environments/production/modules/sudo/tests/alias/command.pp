# File::      <tt>command.pp</tt>
# Author::    Sebastien Varrette (<Sebastien.Varrette@uni.lu>)
# Copyright:: Copyright (c) 2014 Sebastien Varrette (www[http://varrette.gforge.uni.lu])
# License::   GPLv3
#
# ------------------------------------------------------------------------------
# Execute this manifest in your vagrant box as follows:
#
#   sudo puppet apply -t /vagrant/tests/alias/command.pp --noop
#

include 'sudo'

sudo::alias::command{ 'NETWORK':
    cmdlist => [ '/sbin/route', '/sbin/ifconfig', '/bin/ping', '/sbin/dhclient', '/sbin/iptables' ]
}
