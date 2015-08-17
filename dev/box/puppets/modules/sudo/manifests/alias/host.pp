# File::      <tt>host.pp</tt>
# Author::    Sebastien Varrette (<Sebastien.Varrette@uni.lu>)
# Copyright:: Copyright (c) 2011 Sebastien Varrette (www[http://varrette.gforge.uni.lu])
# License::   GPLv3
#
# ------------------------------------------------------------------------------
# = Define: sudo::alias::host
#
# Permits to define a host alias in the sudoers files (directive Host_Alias)
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
# [*comment*]
#   A comment to be placed on top of the definition
#
# [*hostlist*]
#  List of hosts to add in the definition of the alias
#
# [*order*]
#   Placement order of the directive.
#   Default: 20
#
# == Examples
#
#    sudo::alias::host{ 'SERVERS':
#          hostlist => [ '192.168.0.1', '192.168.0.2' ],
#          comment  => 'This is all the servers'
#    }
#    sudo::alias::host{ 'NETWORK':
#          hostlist => [ '192.168.0.0/255.255.255.0' ]
#    }
#    sudo::alias::host{ 'WORKSTATIONS':
#          hostlist => [ 'NETWORK', '!SERVER' ],
#          comment  => 'This is every machine in the network that is not a server'
#    }
#
#    This will create the following entry in the sudoers files:
#
#
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
# [Remember: No empty lines between comments and class definition]
#
define sudo::alias::host(
  $hostlist = [],
  $comment  = '',
  $ensure  = 'present'
)
{
    include sudo::params

    # $name is provided by define invocation
    # guid of this entry
    $hostalias = $name

    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("sudo::alias::host 'ensure' parameter must be set to either 'absent', or 'present'")
    }
    if ($sudo::ensure != $ensure) {
        if ($sudo::ensure != 'present') {
            fail("Cannot configure the sudo host alias '${hostalias}' as sudo::ensure is NOT set to present (but ${sudo::ensure})")
        }
    }

    concat::fragment { "sudoers_host_aliases_${hostalias}":
        target  => $sudo::configfile,
        content => inline_template("<% unless @comment.empty? %># <%= @comment %>\n<% end %>Host_Alias <%= @hostalias.upcase %> = <%= @hostlist.join(', ') %>\n"),
        order   => 55,
        notify  => Exec[$sudo::params::check_syntax_name],
    }


}





