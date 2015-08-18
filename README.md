# honeybee-agavi-cmf-project

### Development setup

This repository holds a `honeybee-agavi-cmf-project` template application which you can use to create your own projects.

#### Checking the prerequisites

* VirtualBox: https://www.virtualbox.org/wiki/Downloads
* VirtualBox Extension Pack: https://www.virtualbox.org/wiki/Download_Old_Builds_4_2
    * either add via Menu: `VirtualBox` -> `File` -> `Preferences` -> `Extensions`
    * or doubleclick the extension pack file after downloading
* Vagrant: http://downloads.vagrantup.com/
* Git: https://git-scm.com

##### Optional devops dependencies

* Ruby: https://www.ruby-lang.org/de/
* Puppet: `gem install puppet`
* Librarian: `gem install librarian-puppet`

#### Setting up `ssh` and `git`

You can configure `git` manually inside your VM or you can preconfigure environment variables to pass into the VM as follows:

* Add `GIT_*` environment-vars in `~/.bashrc` or `~/.bash_profile`:
```shell
PATH=$PATH:/opt/vagrant/bin
export GIT_AUTHOR_NAME="User Name"
export GIT_AUTHOR_EMAIL="your@email.de"
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
```

* Enable `ssh-agent` and environment-vars forwarding in `~/.ssh/config`:
```shell
Host *
ForwardAgent yes
SendEnv LANG LC_* GIT_*
```

#### Initially setting up the project

* To create a new project and VM from this template using `composer`:
```shell
composer.phar create-project -sdev --dev --ignore-platform-reqs --no-install \
honeybee/honeybee-agavi-cmf-project <your-honeybee-project-dir>
```
You will be prompted for for some information to configure the VM.

* In order to launch the VM your application must be made available on Github. When the repository is ready at the location you specified in the `create-project` command you can build the VM as follows:
```shell
cd honeybee-agavi-cmf-project/dev/box/
vagrant up # this will take a while, time to grab a coffee
```

* Now you can install your application within the box:
```shell
vagrant ssh
cd /srv/www/honeybee-agavi-cmf-project.local/
make install
```

In the end you'll be prompted for some infos. Here are some answers, that are suitable for development:

* Base-url: `https://honeybee-agavi-cmf-project.local/`
* Environment: `development`
* Enable testing: `y`

#### Mounting the source

* MAC:
    * In the Finder's menubar select: `Connect to Server`
    * then enter the following address: `nfs://honeybee-agavi-cmf-project.local/srv/www/`
* Ubuntu:
```shell
mount honeybee-agavi-cmf-project.local:/srv/www/ /home/${USER}/projects/honeybee-agavi-cmf-project
```

When successfully setup the application should be reachable at: https://honeybee-agavi-cmf-project.local/
and is ready for development. 

Run the migrations to complete the setup:
```shell
make migrate-all
```

#### Creating the first system account user/admin

The first user within the system must be created via command line using:
```shell
make user
```

This will give an output similar to:
```
Please set a password for the created account at: https://honeybee-agavi-cmf-project.local/honeybee/system_account/user/password?token=c469090bf62c4d21444cd0a83171b1429a11ad9b
Via CLI use the following: bin/cli honeybee.system_account.user.password '-token' 'c469090bf62c4d21444cd0a83171b1429a11ad9b'
```

Either copy the displayed url and open it in a browser or run the displayed cli command. Then follow through the instructions in order to set the password for the user, that you just created.

#### Controlling system services

The following services are running on the cms devbox and are controlled via systemd:

* couchdb
    * http-endpoint: http://honeybee-agavi-cmf-project.local:5984
    * web-client: http://honeybee-agavi-cmf-project.local:5984/_utils
* elasticsearch
    * http-endpoint: http://honeybee-agavi-cmf-project.local:9200
    * web-client: http://honeybee-agavi-cmf-project.local:9200/_plugin/head
* converjon
    * http-endpoint: https://honeybee-agavi-cmf-project.local/converjon
    * web-status: https://honeybee-agavi-cmf-project.local/converjon/status
* nginx
    * cms http-endpoint: https://honeybee-agavi-cmf-project.local/
* php-fpm

In order to start/stop services or get the status use the corresponding sudo command within the devbox, e.g.:
```shell
sudo service couchdb status|start|stop|restart
```

#### Turning the VM on/off

Whenever possible stop the box with:
```shell
vagrant suspend
```
and wake it up again using:
```shell
vagrant resume
```
This will send the box asleep, instead of completely shutting it off and thus runs faster.
The box's network interfaces are not reconfigured using suspend/resume though.
For this the virtual machine needs to be completely rebooted, which can be done by calling:
```shell
vagrant reload # is the same as: vagrant halt && vagrant up
```

In order to apply new infrastructure changes to the box run:
```shell
vagrant provision
```
