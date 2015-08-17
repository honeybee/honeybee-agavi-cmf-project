# File::      <tt>user.pp</tt>
# Author::    Sebastien Varrette (<Sebastien.Varrette@uni.lu>)
# Copyright:: Copyright (c) 2011 Sebastien Varrette (www[http://varrette.gforge.uni.lu])
# License::   GPLv3
#
# ------------------------------------------------------------------------------
# = Define: sudo::alias::user
#
# Permits to define a user alias in the sudoers files (directive User_Alias)
# These aren't often necessary, as you can use regular groups
# (ie, from files, LDAP, NIS, etc) in this file - just use %groupname
# rather than USERALIAS
#
# == Pre-requisites
#
# * The class 'sudo' should have been instanciated
#
# == Parameters:
#
# [*ensure*]
#   default to 'present', can be 'absent'
#   Default: 'present'
#
# [*userlist*]
#  List of users to add in the definition of the alias
#
# [*order*]
#   Placement order of the directive.
#   Default: 25
#
# == Examples
#
#    sudo::alias::user{ 'ADMINS':
#          userlist => [ 'jsmith', 'mikem' ]
#    }
#
#    This will create the following entry in the sudoers files:
#    User_Alias ADMINS = jsmith, mikem
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
# [Remember: No empty lines between comments and class definition]
#
define sudo::alias::user(
    $userlist = [],
    $ensure   = 'present',
    $order    = 25
)
{
    include sudo::params

    # $name is provided by define invocation
    # guid of this entry
    $groupname = $name

    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("sudo::alias::user 'ensure' parameter must be set to either 'absent', or 'present'")
    }
    if ($sudo::ensure != $ensure) {
        if ($sudo::ensure != 'present') {
            fail("Cannot configure the sudo user alias '${groupname}' as sudo::ensure is NOT set to present (but ${sudo::ensure})")
        }
    }

    concat::fragment { "sudoers_user_aliases_${groupname}":
        target  => $sudo::configfile,
        content => inline_template("User_Alias <%= groupname.upcase %> = <%= userlist.join(', ') %>\n"),
        order   => $order,
        notify  => Exec[$sudo::params::check_syntax_name],
    }


}





