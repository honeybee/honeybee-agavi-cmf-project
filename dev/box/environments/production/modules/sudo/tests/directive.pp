# File::      <tt>directive.pp</tt> 
# Author::    Sebastien Varrette (<Sebastien.Varrette@uni.lu>)
# Copyright:: Copyright (c) 2014 Sebastien Varrette (www[http://varrette.gforge.uni.lu])
# License::   GPLv3
# 
# ------------------------------------------------------------------------------
# Execute this manifest in your vagrant box as follows:
#
#   sudo puppet apply -t /vagrant/tests/directive.pp --noop

class { 'sudo':
    configfile => '/tmp/sudoers'
}

sudo::directive {'vagrant':
    content => "vagrant ALL=NOPASSWD:ALL\n"
}

sudo::directive {'admin_users':
    content => "%admin ALL=(ALL) ALL\n",
}
