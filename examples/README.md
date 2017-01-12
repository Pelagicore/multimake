Examples
========

Example : build GENIVI IVI packages
-----------------------------------

This makefile lets you build and install some of the GENIVI DLT and the ivi-logging package. Issue the following commands:
```
$ cd multimake/examples/BuildIVIPackages
$ mkdir build
$ cd build
$ PATH=$PATH:../../..:../../layers cmake .. -DCMAKE_INSTALL_PREFIX=$PWD/install
$ make ivi-logging
```

You should now have a directory called "install" in the build directory, where the packages have been installed. You can start the example application with the following command:
```
$ LD_LIBRARY_PATH=./install/lib ldd ./install/bin/logging-example
```
