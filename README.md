Main Page
=========

Introduction
------------

This documentation describes the Multimake package.
The purpose of this software is to help you build multiple software packages for your system. The tool handles package dependencies in such a way that every package is built only as soon as all the required dependencies have been built.

Features
--------

- Parallel build. Several packages can be built simultaneously if they don't have interdependencies.
- Support of CMake packages
- Support of QMake packages
- Support of Automake packages
- Support of Maven packages
- Support of package installation in non-standard location (prefix)


Design
------

The package is a thin wrapper around the "ExternalProject" CMake module. It provides macros which are more convenient to use than the ones of "ExternalProject".


Examples
--------

Examples can be found in the [examples](examples/README.md) folder


Known limitations
-----------

- Dependee packages must be defined before dependers.


Tips
----

 - If a specific package is already available in your system, or if you simply want CMake not to build it, you can add the following command. Note that this line must be written before the package is defined:
```
add_available_package(packageName)
```

 - You can also exclude a package by adding it to the "EXCLUDED_PACKAGES" variable. By using that technique, you can reuse an existing "CMakeLists.txt" file. Example:
```
  $ PATH=$PATH:/Path/To/Layer1:/Path/To/Layer2; cmake -DEXCLUDED_PACKAGES="package1;package2" -DCMAKE_INSTALL_PREFIX=/My/Install/Prefix /Path/To/Folder/Containing/MyCMakeLists.txt
```

 - By default, the "master" branch of a component is used. If you want to use a specific branch/tag/commit, you can use the following line. That line must be before the definition of the package:
```
set_external_git_project_commit(packageName branch-or-tag-or-commitID)
```


TODO
----

 - Make the generated "make" file executable.


FAQ
---

 - Q : How can I rebuild only one package without building its dependencies ?
 
   A : Use the following command :
```
$ sh make PackageToRebuild/fast
```

 - Q : How can I build all the dependencies of a package ?
 
   A : Use the following command :
```
$ sh make PackageToRebuild_deps
```

 - Q : How can I install the packages on a non-standard location (different from /usr/local).

   A : When invoking cmake to prepare your build folder, set the CMAKE_INSTALL_PREFIX variable:
   ```
   $ PATH=$PATH:/Path/To/Layer1:/Path/To/Layer2; cmake -DCMAKE_INSTALL_PREFIX=/My/Install/Prefix /Path/To/Folder/Containing/MyCMakeLists.txt
   ```
   
 - Q : How can I choose between Release/Debug mode when building the packages ?

   A : You can specify the value of the boolean option called "ENABLE_DEBUG" when invoking cmake::
   ```
   $ PATH=$PATH:/Path/To/Layer1:/Path/To/Layer2; cmake -DENABLE_DEBUG=OFF /Path/To/Folder/Containing/MyCMakeLists.txt
   ```
   Note that the default value is "ON", which means packages are built in debug mode by default. 
   