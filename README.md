The Honeybee-Agavi Content Management Framework (CMF) is based on the [Honeybee][1] CQRS and Event Sourcing library which includes framework bindings for the [Agavi][2] MVC framework. It provides a modular and scalable application infrastructure to facilitate construction of sophisticated content managment systems (CMS) while supporting a Domain Driven Design (DDD) methodology.

 * [Installation](#installation)
   * [Installation inside a VM](#installing-the-application-inside-a-vm)
   * [Installation locally](#installation-locally) (coming soon...)
 * [Initialisation](#initialisation)
 * [Cookbook][5]

**This project is in active development**. Changes may be frequent until releases are provided.

#Installation
Installation of an application can be done directly from this project repository following the instructions provided. 

##Installing the application inside a VM
These instructions detail the procedure for boostrapping your application on a virtual machine (VM).  The VM will be provisioned and configured with the required environment for Honeybee applications.

###Prerequisites
 * `VirtualBox` - https://www.virtualbox.org/wiki/Downloads
 * `git` - https://git-scm.com
 * `vagrant` - http://downloads.vagrantup.com
 * `composer` - https://getcomposer.org/download
 * A Github account and repository for your application
 * Some knowledge of the [Agavi][2] MVC framework is advantageous

###Creating a new project
Creating a project with `composer` will guide you through configuring a project and VM for a new application. We ignore platform requirements because the project will be installed inside the VM.

```shell
# replace the last argument with your chosen folder name if required
composer create-project -sdev --ignore-platform-reqs --no-install \
honeybee/honeybee-agavi-cmf-project honeybee-agavi-cmf-project
```

The repository will be cloned and a post-install script will be executed which will prompt you with some simple configuration questions.

 * When asked for a Github repository you should pick a repository name that you have write access to and is accessible by your VM. Your application will need to be pushed to this repository so the VM can launch, clone and install.
 * When asked to configure a VM you should answer `yes`
 * When asked for a hostname, you can accept the default based on your repository name or choose another HTTPS URL instead, where your application will be hosted inside the VM.
 * When asked by `composer` if you wish to keep the VCS files, you may answer `no`

###Initialising your repository
Your application is now configured and ready for committing to your own repository. Detailed instructions on creating new repositories on Github from source can be found [here][4]. We have summarised the commands as follows:

```shell
cd honeybee-agavi-cmf-project
git init
git add .
git commit -m 'Initialising project'
# replace the following Github repository url with your own
git remote add origin git@github.com:honeybee/honeybee-agavi-cmf-project.git
git push origin master
```

###Launching the VM
When your new repository is publicly available, the VM is ready to launch. When the VM is first initialised, it will clone the Github repository you just created. You can start the machine with the following commands:

```shell
cd honeybee-agavi-cmf-project/dev/box
vagrant up
# please wait, the virtual machine will be downloaded and installed
# provisioning can take up to 30 minutes depending on resources
```

You will see console output as the machine image is downloaded and provisioned. During the provisioning you maybe prompted for input and can accept the default in all cases.

###Completing installation
When your VM is up and running you can finish installation by executing the following commands:

```shell
vagrant ssh
cd /srv/www/honeybee-agavi-cmf-project.local
composer install 
# when prompted you should accept the project installation
sudo service nginx restart
```

The application will install all dependencies and build all required resources. This may take several minutes.

###Accessing the CMS
When successfully setup the application should be accessible at: 

https://honeybee-agavi-cmf-project.local/ 

At this point it is ready for use and development, however it will not contain any data at this point. If you have not created a Honeybee application before we recommend that you review the [cookbook][5]. The cookbook will guide you through the creation of a demo application from scratch, explaining many of the concepts you will need to know to build applications on this framework.

Alternatively you may wish to intialise the application from scratch as explained [here](#initialisation).

###Mounting the source

 * Mac OSX:
    * In the Finder menu:
      * Select *Connect to Server... (⌘K)*
      * Enter the following address: `nfs://honeybee-agavi-cmf-project.local/srv/www/`
 * Ubuntu/Linux:
   * `mount honeybee-agavi-cmf-project.local:/srv/www/ /home/${USER}/projects/honeybee-agavi-cmf-project`

###Controlling system services
The following main services are running on the VM and are controlled via `systemd`:

 * Couchdb
   * http-endpoint: http://honeybee-agavi-cmf-project.local:5984
   * web-client: http://honeybee-agavi-cmf-project.local:5984/_utils
 * Elasticsearch
   * http-endpoint: http://honeybee-agavi-cmf-project.local:9200
   * web-client: http://honeybee-agavi-cmf-project.project:9200/_plugin/head
 * Converjon
   * http-endpoint: https://honeybee-agavi-cmf-project.local/converjon
   * web-status: https://honeybee-agavi-cmf-project.local/converjon/status
 
In order to start/stop services or get the status, use the corresponding `sudo` command within the VM.

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

This will send the box asleep, instead of completely shutting it off and thus runs faster. The box's network interfaces are not reconfigured using suspend/resume though. For this the virtual machine needs to be completely rebooted, which can be done by calling:

```shell
vagrant reload # is the same as: vagrant halt && vagrant up
```

##Installation locally
Coming soon...

##Initialisation
When a Honeybee CMF project is first installed, the databases are not initialised and there is no data in the system.

###Initialising the stores
System migrations are provided for creating administration users. We can execute all pending migrations and initialise the data stores using the following command:

```shell
composer migration-run -- --all
```

On completion you will see a summary of which migrations were executed. There is no data in the system at this point.

###Creating an administrative user
We can create an administration user with the following command.

```shell
composer user-create
```

The command will prompt for a user name and email address. Enter your choices following the command instructions, then follow instructions for setting a password. You may then login to the system at https://honeybee-agavi-cmf-project.local/ with your newly created account.

---
######User registration and email services
In normal user registration flows, users are sent account verification emails. In a development environment the mail service is stubbed and will not actually send emails.

---

[1]: https://github.com/honeybee/honeybee
[2]: https://github.com/agavi/agavi
[3]: https://github.com/honeybee/honeybee-agavi-cmf-project
[4]: https://help.github.com/articles/adding-an-existing-project-to-github-using-the-command-line
[5]: https://github.com/honeybee/honeybee-agavi-cmf-demo/blob/master/cookbook/README.md
