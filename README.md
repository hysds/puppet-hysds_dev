# HySDS dev

Puppet module to install all dependencies needed for HySDS build and develop.

## Prerequisites
Create a base CentOS7 image as described [here](https://github.com/hysds/hysds-framework/wiki/Puppet-Automation#create-a-base-centos-7-image-for-installation-of-all-hysds-component-instances).

## VM/Bare-metal Installation
As _root_ run:
```
cd /etc/puppet/modules
git clone https://github.com/hysds/puppet-hysds_dev.git hysds_dev
cd hysds_dev
./install.sh <github org> <branch>
```

## Build Docker images based on CentOS and CUDA images
```
./build_docker.sh <tag> <github org> <github repo branch>
```
