# elasticsearch
## Overview

This module provides elasticsearch

## Setup
### Select a version
You may select a branch to deploy via hiera (or edit the module). Right now there are two supported branches 
```
elasticsearch::branch: '1.5'
or 
elasticsearch::branch: '2.3'
```

### Changing Version
The module simply deploy repos for zypper and install a package "elasticsearch". Wenn changing repos you have to disable the unwanted repository by hand to make zypper install the correct package.
```
sudo zypper removerepo 'OpenSuse_Elasticsearch 1.5'
sudo zypper in elasticsearch-2.3.3
or
sudo zypper removerepo 'OpenSuse_Elasticsearch 2.3'
sudo zypper in elasticsearch-1.5.1
```

### Removing old versions
Older version of this elasticsearch module deployed the packages with different namings. In Order to clean this up you have to remove the packages by hand.
```
sudo zypper removerepo 'OpenSuse_Elasticsearch'
sudo zypper rm elasticsearch-1.5.1
```