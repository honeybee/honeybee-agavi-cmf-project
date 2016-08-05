# File::      <tt>user.pp</tt> 
# Author::    Sebastien Varrette (<Sebastien.Varrette@uni.lu>)
# Copyright:: Copyright (c) 2014 Sebastien Varrette (www[http://varrette.gforge.uni.lu])
# License::   GPLv3
# 
# ------------------------------------------------------------------------------
# Execute this manifest in your vagrant box as follows:
#
#   sudo puppet apply -t /vagrant/tests/alias/user.pp --noop
#

class { 'sudo':
    configfile => '/tmp/sudoers'
}

sudo::alias::user{ 'ADMINS':
    userlist => [ 'jsmith', 'mikem' ]
}
