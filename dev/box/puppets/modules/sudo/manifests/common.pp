# File::      <tt>common.pp</tt>
# Author::    Sebastien Varrette (<Sebastien.Varrette@uni.lu>)
# Copyright:: Copyright (c) 2015 Sebastien Varrette (www[])
# License::   GPLv3
#
# ------------------------------------------------------------------------------
# = Class sudo::common
#
# Base class to be inherited by the other sudo classes, containing the common code.
#
# Note: respect the Naming standard provided here[http://projects.puppetlabs.com/projects/puppet/wiki/Module_Standards]
class sudo::common {

    # Load the variables used in this module. Check the ssh-server-params.pp file
    require sudo::params

    # $package_ensure = $sudo::ensure ? {
    #     'absent' => 'purged',
    #     default  => $sudo::ensure
    # }
    #notice("sudo::ensure = $sudo::ensure")
    package { 'sudo':
        ensure => $sudo::ensure,
        name   => $sudo::params::packagename,
    }

    if ($sudo::ensure == 'present') {

        # eventually backup old version
        # exec { "backup ${sudo::params::configfile}":
        #     command => "cp ${sudo::params::configfile} ${sudo::params::backupconfigfile}",
        #     path    => "/usr/bin:/usr/sbin:/bin",
        #     creates => "${sudo::params::backupconfigfile}",
        #     onlyif  => "test -f ${sudo::params::configfile}",
        #     #unless  => "test -f ${sudo::params::backupconfigfile}",
        #     #require => Package['sudo'],
        #     #before  => Concat["${sudo::params::configfile}"],
        # }

        # Package['sudo'] -> Exec["backup ${sudo::params::configfile}"]
        # #-> Concat["${sudo::params::configfile}"]

        #include concat::setup -- Now deprecated

        concat { $sudo::configfile:
            warn    => true,
            owner   => $sudo::params::configfile_owner,
            group   => $sudo::params::configfile_group,
            mode    => $sudo::params::configfile_mode,
            require => Package['sudo'],
            notify  => Exec[$sudo::params::check_syntax_name]
        }

        # Header of the file
        concat::fragment { 'sudoers_header':
            target => $sudo::configfile,
            source => 'puppet:///modules/sudo/01-sudoers_header',
            order  => 01,
        }

        # Header of the User aliases
        concat::fragment { 'sudoers_user_aliases_header':
            target => $sudo::configfile,
            source => 'puppet:///modules/sudo/20-sudoers_user_aliases_header',
            order  => 20,
        }


        # Header of the Command aliases
        concat::fragment { 'sudoers_command_aliases_header':
            target  => $sudo::configfile,
            content => template('sudo/40-sudoers_command_aliases_header.erb'),
            order   => 40,
        }

        # Header of the Host aliases
        concat::fragment { 'sudoers_host_aliases_header':
            target => $sudo::configfile,
            source => 'puppet:///modules/sudo/50-sudoers_host_aliases_header',
            order  => 50,
        }

        # Header of the Defaults specs
        concat::fragment { 'sudoers_default_specs_header':
            target  => $sudo::configfile,
            content => template('sudo/60-sudoers_default_specs.erb'),
            order   => 60,
        }

        # Header of the main part
        concat::fragment { 'sudoers_mainheader':
            target => $sudo::configfile,
            source => 'puppet:///modules/sudo/80-sudoers_main_header',
            order  => 80,
        }

        if versioncmp($::sudoversion,'1.7.1') > 0 {
            #
            # Use the #includedir directive to manage sudoers.d, version >= 1.7.2
            #
            concat::fragment { 'sudoers_footer_includedir':
                target  => $sudo::configfile,
                content => "\n#includedir ${sudo::params::configdir}\n",
                order   => 99,
            }

            file { $sudo::configdir:
                ensure  => 'directory',
                owner   => $sudo::params::configdir_owner,
                group   => $sudo::params::configdir_group,
                mode    => $sudo::params::configdir_mode,
                purge   => true,
                recurse => true,
            }
        }

        # check the syntax of the sudoers files
        exec {$sudo::params::check_syntax_name:
            path        => '/usr/bin:/usr/sbin:/bin',
            command     => "visudo -c -f ${sudo::configfile}",
            returns     => 0,
            onlyif      => "test \"${sudo::ensure}\" == \"present\"",
            refreshonly => true,
            logoutput   => 'on_failure',
        }

    }
    else
    {
        # here $sudo::ensure is 'absent'

        # # Restore old sudoers file (if it exists)
        # exec { "restore ${sudo::configfile}":
        #     command => "mv ${sudo::params::backupconfigfile} ${sudo::configfile}"
        #     path    => "/usr/bin:/usr/sbin:/bin",
        #     onlyif  => "test -f ${sudo::params::backupconfigfile}",
        #     #before  => Package['sudo'],
        # }

        # Delete /etc/sudoers.d if sudo version >= 1.7.2
        if versioncmp($::sudoversion,'1.7.1') > 0 {

            file { $sudo::params::configdir:
                ensure => 'absent',
                force  => true,
                #purge   => true,
                #recurse => true,
                #onlyif  => "test -d ${sudo::params::configdir}",
            }
        }
    }


}
