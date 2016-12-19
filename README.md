# What is this?
This repo aids in the compilation of statically linked openvpn binaries for easy distribution to Linux, Mac, and Windows systems.
## How To Use:
#### *Note*: If docker is not available, Vagrant may be used for the build environment.
### Building with Vagrant:
From inside the code directory:
```
$ vagrant up
$ vagrant ssh
$ cd vagrant
$ make
```
### Building with Docker:
From inside the code directory:
```
$ make
```
### Publishing binaries:
*note*: This requires aws client to be installed and configured.
```
$ make publish
```