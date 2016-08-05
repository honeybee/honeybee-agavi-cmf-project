# Puppet Recipes

- currently made for OpenSuse 13.2
- will work with few modifications for 13.1 and Ubuntu/debian
- full readme will come with various parameters.

To use these puppets for a Honeybee application you need to download some files. There is a template to get you started: https://gitlab.berlinonline.net/puppets/deploy-template

# Requirements

- Virtualbox
- Vagrant >= 1.7
- librarian-puppet
- Puppet on your host machine >= 3.7 (libriarian-puppet requires puppet)

# Deployment

- Get the puppets directory from "https://gitlab.berlinonline.net/puppets/deploy-template"
- Get a Vagrantfile (working configuration see deploy template) and place it according to directory layout below
- You will want to overrwrite parameters like converjon alias paths etc, so include own devbox.yaml according to Directory Layout (see below)
- The default Honeybee Role checks out your desired Repo with : `berlinonline::project_git_path:"git@github.com:your/honeybee-project.git"` (permissions)
- Adjust your privat ssh key path `config.ssh.private_key_path = ['~/.vagrant.d/insecure_private_key', '~/.ssh/id_dsa']`
- If you think everything is correct run `librarian-puppet install`
- run `vagrant up`


## Directory Layout:

```
/Vagrantfile
/puppets/...
/puppets/devbox.yaml
/puppets/hiera/...
```

## Hiera

BerlinOnline makes heavy use of hiera, so your hiera directory has to look like this :

```
hiera/global.yaml
hiera/devbox.yaml
hiera/hiera.yaml
hiera/operatingsystem/OpenSuSE.yaml
hiera/operatingsystem/Ubuntu.yaml
```

## Local configuration files

You may deploy local configs for your application using hiera. The needed ```local_conf``` module is included into the `server` role, so it should be used for all deployments. Right now there is application-specific deployment only located under ```/usr/local/${fqdn}```. Valid providers are `json` and `yaml`.

Usage:

```yaml
local_conf:
     application:
       -
         file: aws_s3.json
         provider: json
         content:
           secret: omgomgomgomgomgomgomg
           bucket: foo
       -
        file: middleware.json
        provider: json
        content:
          host: somehost
          protocol: 'https'
          foobar:
            - base_url_path
            - foo
            - bar
```

## Releases

### 0.5.0

Added `berlinonline-redis` and `berlinonline-rabbitmq` puppet repos to be able to use them in roles

### 0.4.0

Moved most of the PHP related stuff into the berlinonline php puppet module – see https://gitlab.berlinonline.net/puppets/php

### 0.2.0*

This was a major Release since we removed the old app/cms roles and unified it into a single application with http/https switch. The software and config is still the same, execept for nginx https stuff.
You will have to fix your hiera yaml with the new template to use the application parameters.
