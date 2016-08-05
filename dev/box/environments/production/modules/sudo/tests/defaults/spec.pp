# File::      <tt>spec.pp</tt> 
# Author::    Sebastien Varrette (<Sebastien.Varrette@uni.lu>)
# Copyright:: Copyright (c) 2014 Sebastien Varrette (www[http://varrette.gforge.uni.lu])
# License::   GPLv3
# 
# ------------------------------------------------------------------------------
# Execute this manifest in your vagrant box as follows:
#
#   sudo puppet apply -t /vagrant/tests/defaults/spec.pp --noop
#

include 'sudo'

sudo::defaults::spec { 'env_keep':
        content => "
Defaults    env_reset
Defaults    env_keep =  \"COLORS DISPLAY HOSTNAME LS_COLORS\"
Defaults    env_keep += \"MAIL PS1 PS2 USERNAME LANG LC_ADDRESS LC_CTYPE\"
Defaults    env_keep += \"LC_COLLATE LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES\"
Defaults    env_keep += \"LC_TIME LC_ALL LANGUAGE\"\n",
}
