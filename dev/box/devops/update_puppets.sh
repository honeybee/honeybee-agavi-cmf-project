#!/bin/sh

librarian-puppet update
rm -rf ../puppets/modules
cp -rf modules ../puppets/
find ../puppets/modules -name .git -exec rm -rf {} \;
rm -rf ../puppets/manifests
cp -rf manifests ../puppets/
find ../puppets/manifests -name .gitmodules -exec rm -rf {} \;
