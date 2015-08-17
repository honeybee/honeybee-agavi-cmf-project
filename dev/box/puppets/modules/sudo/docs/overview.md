-*- mode: markdown; mode: visual-line;  -*-

# Sudo Puppet Module 

[![Puppet Forge](http://img.shields.io/puppetforge/v/ULHPC/sudo.svg)](https://forge.puppetlabs.com/ULHPC/sudo)
[![License](http://img.shields.io/:license-gpl3.0-blue.svg)](LICENSE)
![Supported Platforms](http://img.shields.io/badge/platform-debian|redhat|centos-lightgrey.svg)
[![Documentation Status](https://readthedocs.org/projects/ulhpc-puppet-sudo/badge/?version=stable)](https://readthedocs.org/projects/ulhpc-puppet-sudo/?badge=stable)

Configure and manage sudo and sudoers files

       Copyright (c) 2011-2015 S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka.
                    the UL HPC Management Team <hpc-sysadmins@uni.lu>
      

| [Project Page](https://github.com/ULHPC/puppet-sudo) | [Documentation](http://ulhpc-puppet-sudo.readthedocs.org/en/latest/) | [Sources](https://github.com/ULHPC/puppet-sudo)  | [Issues](https://github.com/ULHPC/puppet-sudo/issues)  |

## Synopsis

Manage sudo configuration via Puppet.

This module implements the following elements: 

* __Puppet classes__:
    - `sudo`: main class 
    - `sudo::common` 
    - `sudo::common::debian`: specific implementation under Debian 
    - `sudo::common::redhat`: specific implementation under Redhat-like system 
    - `sudo::params`: class parameters 

* __Puppet definitions__: 
    - `sudo::alias::command`: defines a command alias in the sudoers files (directive `Cmnd_Alias`) 
    - `sudo::alias::user`: defines a user alias in the sudoers files (directive `User_Alias`) 
    - `sudo::defaults::spec`: defines a default specifications (directive `Defaults`) 
    - `sudo::directive`: generic way to write sudoers configurations parts

All these components are configured through a set of variables you will find in
[`manifests/params.pp`](manifests/params.pp). 

_Note_: the various operations that can be conducted from this repository are piloted from a [`Rakefile`](https://github.com/ruby/rake) and assumes you have a running [Ruby](https://www.ruby-lang.org/en/) installation.
See `docs/contributing.md` for more details on the steps you shall follow to have this `Rakefile` working properly. 

## Dependencies

See [`metadata.json`](metadata.json). In particular, this module depends on 

* [puppetlabs/stdlib](https://forge.puppetlabs.com/puppetlabs/stdlib)
* [puppetlabs/concat](https://forge.puppetlabs.com/puppetlabs/concat)

## Overview and Usage

### Class `sudo`

This is the main class defined in this module.
Use it as follows:

     include ' sudo'

See also [`tests/init.pp`](tests/init.pp)

### Definition `sudo::directive`

The definition `sudo::directive` provides a simple way to write sudo configurations parts.
If you use a `sudo` version >= 1.7.2, the sudo directive part is validated via
`visudo` and removed if syntax is not correct.
This definition accepts the following parameters:

* `$ensure`: default to 'present', can be 'absent' (BEWARE: it will remove the
  associated file) 
* `$content`: specify the contents of the directive as a string
* `$source`: copy a file as the content of the directive.

Example:

      sudo::directive {'admin_users':
           content => "%admin ALL=(ALL) ALL\n",
      }

On recent version of sudo, this will typically create a new file `/etc/sudoers.d/admin_users`.

See also [`tests/directive.pp`](tests/directive.pp)


### Definition `sudo::alias::command`

Permits to define a command alias in the `sudoers` files (directive `Cmnd_Alias`)
These are groups of related commands...

This definition accepts the following parameters:

* `$ensure`: default to 'present', can be 'absent' 
* `$commandlist`: List of commands to add in the definition of the alias

Example: 

     sudo::alias::command{ 'NETWORK':
          cmdlist => [ '/sbin/route', '/sbin/ifconfig', '/bin/ping', '/sbin/dhclient', '/sbin/iptables' ]
     }

This will create the following entry in the sudoers files:

     ## Networking
     Cmnd_Alias NETWORK = /sbin/route, /sbin/ifconfig, /bin/ping, /sbin/dhclient, /sbin/iptables

See also [`tests/alias/command.pp`](tests/alias/command.pp)

### Definition `sudo::alias::user`

Permits to define a user alias in the sudoers files (directive User_Alias)
These aren't often necessary, as you can use regular groups
(ie, from files, LDAP, NIS, etc) in this file - just use `%groupname`
rather than `USERALIAS`

This definition accepts the following parameters:

* `$ensure`: default to 'present', can be 'absent' 
* `$commandlist`: list of users to add in the definition of the alias

Example:

      sudo::alias::user{ 'ADMINS':
          userlist => [ 'jsmith', 'mikem' ]
      }

This will create the following entry in the `sudoers` files:

      User_Alias ADMINS = jsmith, mikem

See also [`tests/alias/user.pp`](tests/alias/user.pp)


### Definition `sudo::defaults::spec`

Permits to define a default specifications
This definition accepts the following parameters:

* `$ensure`: default to 'present', can be 'absent' 
* `$content`: specify the contents of the directive as a string
* `$source`: copy a file as the content of the directive.

Examples

     sudo::defaults::spec { 'env_keep':
           content => "
      Defaults    env_reset
      Defaults    env_keep =  \"COLORS DISPLAY HOSTNAME LS_COLORS\"
      Defaults    env_keep += \"MAIL PS1 PS2 USERNAME LANG LC_ADDRESS LC_CTYPE\"
      Defaults    env_keep += \"LC_COLLATE LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES\"
      Defaults    env_keep += \"LC_TIME LC_ALL LANGUAGE\"\n",
      }

This will create the following entry in the sudoers files:

```
Defaults    env_reset
Defaults    env_keep =  "COLORS DISPLAY HOSTNAME LS_COLORS"
Defaults    env_keep += "MAIL PS1 PS2 USERNAME LANG LC_ADDRESS LC_CTYPE"
Defaults    env_keep += "LC_COLLATE LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES"
Defaults    env_keep += "LC_TIME LC_ALL LANGUAGE"
```

See also [`tests/defaults/spec.pp`](tests/defaults/spec.pp)


## Librarian-Puppet / R10K Setup

You can of course configure the sudo module in your `Puppetfile` to make it available with [Librarian puppet](http://librarian-puppet.com/) or
[r10k](https://github.com/adrienthebo/r10k) by adding the following entry:

     # Modules from the Puppet Forge
     mod "ULHPC/sudo"

or, if you prefer to work on the git version: 

     mod "ULHPC/sudo", 
         :git => 'https://github.com/ULHPC/puppet-sudo',
         :ref => 'production' 

## Issues / Feature request

You can submit bug / issues / feature request using the [ULHPC/sudo Puppet Module Tracker](https://github.com/ULHPC/puppet-sudo/issues). 

## Developments / Contributing to the code 

If you want to contribute to the code, you shall be aware of the way this module is organized. 
These elements are detailed on [`docs/contributing/`](contributing/)

You are more than welcome to contribute to its development by [sending a pull request](https://help.github.com/articles/using-pull-requests). 

## Puppet modules tests within a Vagrant box

The best way to test this module in a non-intrusive way is to rely on [Vagrant](http://www.vagrantup.com/).
The `Vagrantfile` at the root of the repository pilot the provisioning various vagrant boxes available on [Vagrant cloud](https://atlas.hashicorp.com/boxes/search?utf8=%E2%9C%93&sort=&provider=virtualbox&q=svarrette) you can use to test this module.

See [`docs/vagrant.md`](vagrant.md) for more details. 

## Online Documentation

[Read the Docs](https://readthedocs.org/) aka RTFD hosts documentation for the open source community and the [ULHPC/sudo](https://github.com/ULHPC/puppet-sudo) puppet module has its documentation (see the `docs/` directly) hosted on [readthedocs](ulhpc-puppet-sudo.rtfd.org).

See [`docs/rtfd.md`](rtfd.md) for more details.
