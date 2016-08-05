#!/bin/bash +v

# clone master version of deploy-template and selectively copy some files into our template
git clone ssh://git@gitlab.berlinonline.net/puppets/deploy-template.git
rm -rf environments
cp -vR deploy-template/environments .
rm -rf deploy-template
echo ""
echo "DevBox setup updated from latest master version of the deploy-template."
echo ""
echo "Please make sure to adjust local 'Vagrantfile' and 'devbox.yaml' files according to the example files:"
echo ""
echo "https://gitlab.berlinonline.net/puppets/deploy-template/blob/master/Vagrantfile.example"
echo "https://gitlab.berlinonline.net/puppets/deploy-template/blob/master/environments/production/hiera/devbox.yaml.example"
echo ""
