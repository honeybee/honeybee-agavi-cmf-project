# Puppet Recipes

Currently made for OpenSuse 13.2
will work with few modifications for 13.1 and Ubuntu/debian

Full readme will come with various parameters.

To use this puppets for honeybee you need to download some files - BerlinOnline created a template to make it easier (https://gitlab.berlinonline.net/puppets/deploy-template"

# Requirements
* Virtualbox
* Vagrant >= 1.7
* librarian-puppet
* Puppet on your host machine >= 3.7 (libriarian-puppet requires puppet)

# Deployment
* Get the puppets directory from "https://gitlab.berlinonline.net/puppets/deploy-template"
* Get a Vagrantfile (working configuration see deploy template) and place it according to directory layout below
* You will want to overrwrite parameters like converjon alias paths etc, so include own devbox.yaml according to Directory Layout (see below)
* The default Honeybee Role checks out your desired Repo with : `berlinonline::project_git_path:"git@github.com:berlinonline/hb-showcase.git"`, so make sure you have sufficient access to that repo
* Adjust your privat ssh key path `config.ssh.private_key_path = ['~/.vagrant.d/insecure_private_key', '~/.ssh/id_dsa']`
* If you think everything is correct run `librarian-puppet install`
* run `vagrant up`


## Directory Layout:

*/Vagrantfile  
*/puppets/...  
*/puppets/devbox.yaml  
*/puppets/hiera/...  

## Hiera
BerlinOnline makes heavy use of hiera, so your hiera directory has to look like this :

hiera/global.yaml  
hiera/devbox.yaml  
hiera/hiera.yaml  
hiera/operatingsystem/OpenSuSE.yaml  
hiera/operatingsystem/Ubuntu.yaml
