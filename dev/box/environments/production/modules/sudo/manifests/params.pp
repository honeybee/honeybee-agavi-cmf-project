# File::      <tt>params.pp</tt>
# Author::    Sebastien Varrette (Sebastien.Varrette@uni.lu)
# Copyright:: Copyright (c) 2011 Sebastien Varrette
# License::   GPLv3
#
# Time-stamp: <Ven 2014-09-05 21:43 svarrette>
# ------------------------------------------------------------------------------
# = Class: sudo::params
#
# In this class are defined as variables values that are used in other
# sudo classes.
# This class should be included, where necessary, and eventually be enhanced
# with support for more OS
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
# The usage of a dedicated param classe is advised to better deal with
# parametrized classes, see
# http://docs.puppetlabs.com/guides/parameterized_classes.html
#
# [Remember: No empty lines between comments and class definition]
#
class sudo::params {

    ######## DEFAULTS FOR VARIABLES USERS CAN SET ##########################
    # (Here are set the defaults, provide your custom variables externally)
    # (The default used is in the line with '')
    ###########################################

    # ensure the presence (or absence) of sudo
    $ensure = $::sudo_ensure ? {
        ''      => 'present',
        default => $::sudo_ensure
    }

    #### MODULE INTERNAL VARIABLES  #########
    # (Modify to adapt to unsupported OSes)
    #######################################
    $packagename = $::operatingsystem ? {
        default => 'sudo',
    }

    # The actual version of the package is provided by the
    # custore fact 'sudoversion' (see lib/facter/sudo.rb)

    # main configuration file
    $configfile = $::operatingsystem ? {
        default => '/etc/sudoers',
    }
    # backup of the main configuration file
    $backupconfigfile = $::operatingsystem ? {
        default => '/etc/.sudoers.puppet-save-orig',
    }
    
    $configfile_mode = $::operatingsystem ? {
        default => '0440',
    }

    $configfile_owner = $::operatingsystem ? {
        default => 'root',
    }

    $configfile_group = $::operatingsystem ? {
        default => 'root',
    }

    # The next config dir only holds for sudo version >= 1.7.2
    $configdir = $::operatingsystem ? {
        default => '/etc/sudoers.d',
    }
    $configdir_mode = $::operatingsystem ? {
        default => '0755',
    }

    $configdir_owner = $::operatingsystem ? {
        default => 'root',
    }

    $configdir_group = $::operatingsystem ? {
        default => 'root',
    }

    # name of the exec resource responsible for checking the syntax of the sudoers
    # file
    $check_syntax_name = 'sudoers-check-syntax'
    
    $cmdalias_pkgmanager = $::operatingsystem ? {
        /(?i-mx:ubuntu|debian)/         => [ '/usr/bin/apt-get' ],
        /(?i-mx:centos|fedora|redhat|opensuse)/ => [ '/bin/rpm', '/usr/bin/up2date', '/usr/bin/yum', '/usr/bin/zypper' ],
        default => []
    }


}

