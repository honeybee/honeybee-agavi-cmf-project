# File::      <tt>init.pp</tt>
# Author::    Sebastien Varrette (Sebastien.Varrette@uni.lu)
# Copyright:: Copyright (c) 2011 Sebastien Varrette
# License::   GPL-3.0
#
# ------------------------------------------------------------------------------
# = Class: sudo
#
# Configure and manage sudo and sudoers files
#
# == Actions
#
# Install and configure sudo
#
# == Parameters (cf sudo-params.pp)
#
# $ensure:: *Default*: 'present'. The Puppet ensure attribute (can be either 'present' or 'absent') - absent will ensure the sudo package is removed
# $configfile:: *Default*: '/etc/sudoers'. The configuration file to use.
#
# == Requires
#
# n/a
#
# == Sample Usage
#
#     include 'sudo'
#
# You can then specialize the various aspects of the configuration,
# for instance
#
#         class { 'sudo':
#             configfile => '/tmp/sudoers'
#         }
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
#
# [Remember: No empty lines between comments and class definition]
#
class sudo(
  $ensure     = $sudo::params::ensure,
  $configfile = $sudo::params::configfile
  ) inherits sudo::params
{
    info ("Configuring sudo (with ensure = ${ensure})")

    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("sudo 'ensure' parameter must be set to either 'absent' or 'present'")
    }

    $configdir = $configfile ? {
        "${sudo::params::configfile}" => $sudo::params::configdir,
        default                       => "${sudo::configfile}.d"
    }

    case $::operatingsystem {
        debian, ubuntu:         { include sudo::common::debian }
        redhat, fedora, centos, opensuse: { include sudo::common::redhat }
        default: {
            fail("Module ${module_name} is not supported on ${::operatingsystem}")
        }
    }
}

