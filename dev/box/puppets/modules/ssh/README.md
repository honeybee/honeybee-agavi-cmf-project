# SSH module

Puppet module for:

- installing a ssh server (with custom `sshd_config` if wanted)
- creating ssh users (with `~/.ssh/config`)
- creating a custom ssh key for an user

# Usage 

    include ssh::server

or you can add custom source locations for `sshd_config` files:

    class { 'ssh::server':
      source => [
        "puppet:///modules/projects/integration-server/sshd_config",
      ]
    }

or create an user with a custom ssh key:

    # ensure required users are present
    user { 'jenkins':
      ensure => present,
      home => '/home/jenkins'
    } -> file { '/home/jenkins':
      ensure => directory,
      owner => 'jenkins'
    } -> group { 'jenkins':
      ensure => present
    } -> ssh::user { 'jenkins': 
      home => '/home/jenkins'
    } -> ssh::keygen { 'puppet-generated-key-for-jenkins-user':
      user => 'jenkins'
    }

The above `ssh::keygen` creates a private/public key pair `id_rsa` and `id_rsa.pub` in the home directory of the given user.

If you want to customize the comment used within the key and the name of the key you may do so:

    ssh::keygen { 'puppet-generated-key-for-jenkins-user':
      user => 'jenkins',
      comment => 'jenkins@integration-server',
      keyname => 'custom_name'
    }

The above will create a `~/.ssh/id_rsa_${keyname}` (`~/.ssh/id_rsa_custom_name`) file containing `${comment}` (`jenkins@integration-server`) in the public key file. The `comment` defaults to the `title` of the definition. The `keyname` defaults to `id_rsa` or the `comment` if specified (and thus the `title` if no comment was given).
