# honeybee-agavi-cmf-project

This repository holds a ```honeybee-agavi-cmf-project``` application.
@todo figure out the composer.phar create-project command

### Development setup

When successfully setup a "honeybee-agavi-cmf-project" application should be reachable at: https://honeybee-cmf-project.local/

See the ["Controlling system services"](#controlling-system-services) section for further information on available endpoints.

#### Checking the prerequisites

* VirtualBox: https://www.virtualbox.org/wiki/Downloads
* VirtualBox Extension Pack: https://www.virtualbox.org/wiki/Download_Old_Builds_4_2
    * either add via Menu: ```VirtualBox``` -> ```File``` -> ```Preferences``` -> ```Extensions```
    * or doubleclick the extension pack file after downloading
* Vagrant: http://downloads.vagrantup.com/
* Git: https://git-scm.com

##### Optional devops dependencies

* Ruby: https://www.ruby-lang.org/de/
* Puppet: ```gem install puppet```
* Librarian: ```gem install librarian-puppet```

#### Setting up ssh and git

* Add GIT_* environment-vars in ~/.bashrc:
```shell
PATH=$PATH:/opt/vagrant/bin
export GIT_AUTHOR_NAME="User Name"
export GIT_AUTHOR_EMAIL="your@email.de"
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
```

* Enable ssh-agent and env-var forwarding in ~/.ssh/config:
```shell
Host *
ForwardAgent yes
SendEnv LANG LC_* GIT_*
```

#### Initially setting up the project

* Initially create the vagrant box:
```shell
git clone git@github.com:honeybee/honeybee-agavi-cmf-project.git
cd honeybee-cmf-project/dev/box/
vagrant up # this will take a while, time to grab a coffee
```

* Checkout and setup app within the box:
```shell
vagrant ssh
cd /srv/www/honeybee-cmf-project.local/
make install
```

In the end you'll be prompted for some infos. Here are some answers, that are suitable for dev:

* Base-url: ```https://honeybee-cmf-project.local/```
* Environment: ```development```
* Enable testing: ```y```

Afterwards run the migrations to complete the setup:
```shell
make migrate-all
```

#### Creating the first system-account user/admin

The first user within the system must be created via command line using:
```shell
make user
```

This will give an output similar to:
```
Please set a password for the created account at: https://honeybee-cmf-project.local/foh/system_account/user/password?token=c469090bf62c4d21444cd0a83171b1429a11ad9b
Via CLI use the following: bin/cli foh.system_account.user.password '-token' 'c469090bf62c4d21444cd0a83171b1429a11ad9b'
```

Either copy the displayed url and open it in a browser or run the displayed cli command. Then follow through the instructions in order to set the password for the user, that you just created.

#### Mounting the source

* MAC:
    * In the Finder's menubar select: ```Connect to Server```
    * then enter the following address: ```nfs://honeybee-cmf-project.local/srv/www/```
* Ubuntu:
```shell
mount honeybee-cmf-project.local:/srv/www/ /home/${USER}/projects/honeybee-cmf-project
```

#### Controlling system services

The following services are running on the cms devbox and are controlled via systemd:

* couchdb
    * http-endpoint: http://honeybee-cmf-project.local:5984
    * web-client: http://honeybee-cmf-project.local:5984/_utils
* elasticsearch
    * http-endpoint: http://honeybee-cmf-project.local:9200
    * web-client: http://honeybee-cmf-project.local:9200/_plugin/head
* converjon
    * http-endpoint: https://honeybee-cmf-project.local/converjon
    * web-status: https://honeybee-cmf-project.local/converjon/status
* nginx
    * cms http-endpoint: https://honeybee-cmf-project.local/
* php-fpm

In order to start/stop services or get the status use the corresponding sudo command within the devbox, e.g.:
```shell
sudo service couchdb status|start|stop|restart
```

#### Turning the devbox on/off

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
