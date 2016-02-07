#!/bin/bash

# clone master version of deploy-template and selectively copy some files into our template
git clone https://gitlab.berlinonline.net/puppets/deploy-template.git
cp deploy-template/Gemfile* .
cp deploy-template/puppets/manifests/* ./manifests
cp deploy-template/puppets/Puppetfile ./Puppetfile
cp deploy-template/puppets/hiera/hiera.yaml ./hiera/
cp deploy-template/puppets/hiera/global.yaml ./hiera/
cp deploy-template/puppets/hiera/operatingsystem/* ./hiera/operatingsystem/
rm -rf deploy-template

# do the actual puppet module updates and copy them into the correct folder
librarian-puppet update
rm -rf ../puppets/modules
cp -rf modules ../puppets/
find ../puppets/modules -name .git* -exec rm -rf {} \;
rm -rf ../puppets/manifests
cp -rf manifests ../puppets/
find ../puppets/manifests -name .git* -exec rm -rf {} \;
cp -rf hiera ../puppets
