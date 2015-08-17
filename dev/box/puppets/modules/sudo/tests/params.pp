# File::      <tt>params.pp</tt>
# Author::    S. Varrette, H. Cartiaux, V. Plugaru (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2014 S. Varrette, H. Cartiaux, V. Plugaru
# License::   Gpl-3.0
#
# ------------------------------------------------------------------------------
# You need the 'future' parser to be able to execute this manifest (that's
# required for the each loop below).
#
# Thus execute this manifest in your vagrant box as follows:
#
#      sudo puppet apply -t --parser future /vagrant/tests/params.pp
#
#

include 'sudo::params'

$names = ['ensure','packagename','configfile','backupconfigfile','configfile_mode','configfile_owner','configfile_group','configdir','configdir_mode','configdir_owner','configdir_group','check_syntax_name','cmdalias_pkgmanager']

notice("sudo::params::ensure  = ${sudo::params::ensure }")
notice("sudo::params::packagename  = ${sudo::params::packagename }")
notice("sudo::params::configfile  = ${sudo::params::configfile }")
notice("sudo::params::backupconfigfile  = ${sudo::params::backupconfigfile }")
notice("sudo::params::configfile_mode  = ${sudo::params::configfile_mode }")
notice("sudo::params::configfile_owner  = ${sudo::params::configfile_owner }")
notice("sudo::params::configfile_group  = ${sudo::params::configfile_group }")
notice("sudo::params::configdir  = ${sudo::params::configdir }")
notice("sudo::params::configdir_mode  = ${sudo::params::configdir_mode }")
notice("sudo::params::configdir_owner  = ${sudo::params::configdir_owner }")
notice("sudo::params::configdir_group  = ${sudo::params::configdir_group }")
notice("sudo::params::check_syntax_name  = ${sudo::params::check_syntax_name }")
notice("sudo::params::cmdalias_pkgmanager  = ${sudo::params::cmdalias_pkgmanager }")

#each($names) |$v| {
#    $var = "sudo::params::${v}"
#    notice("${var} = ", inline_template('<%= scope.lookupvar(@var) %>'))
#}
