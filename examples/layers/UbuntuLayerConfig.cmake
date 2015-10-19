#
# Multimake
# Copyright (C) 2015 Pelagicore AB
#
# Permission to use, copy, modify, and/or distribute this software for 
# any purpose with or without fee is hereby granted, provided that the 
# above copyright notice and this permission notice appear in all copies. 
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL 
# WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED  
# WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR 
# BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES 
# OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, 
# WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, 
# ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS 
# SOFTWARE.
#
# For further information see LICENSE

# This file contains the definition of packages which are available out of the box on Debian/Ubuntu systems

find_package(Multimake)

macro(add_available_ubuntu_package PACKAGE DEBIAN_PACKAGES)
	set(REQUIRED_DEBIAN_PACKAGES  "${REQUIRED_DEBIAN_PACKAGES} ${DEBIAN_PACKAGES}" )
	add_available_package(${PACKAGE})
endmacro()

add_available_ubuntu_package(glib "libglib2.0-dev")
add_available_ubuntu_package(gupnp-1.0 "libgupnp-1.0-dev")
add_available_ubuntu_package(gupnp-av-1.0 "libgupnp-av-1.0-dev")
add_available_ubuntu_package(gupnp-dlna-2.0 "libgupnp-dlna-2.0-dev")

add_available_ubuntu_package(zlib "zlib1g-dev")



add_available_ubuntu_package(taglib "libtag1-dev")
add_available_ubuntu_package(libarchive "libarchive-dev")

add_available_ubuntu_package(wayland "libwayland-dev")
add_available_ubuntu_package(maven "maven")

add_available_ubuntu_package(autotools "automake")
add_available_ubuntu_package(libtool "libtool")
add_available_ubuntu_package(dbus "libdbus-1-dev")
add_available_ubuntu_package(dbus-cpp "libdbus-cpp-dev")
add_available_ubuntu_package(expat "libexpat1-dev")
add_available_ubuntu_package(glibmm "libglibmm-2.4-dev")
add_available_ubuntu_package(libcrypto "libssl-dev")

add_available_ubuntu_package(libxtst libxtst-dev )
add_available_ubuntu_package(libpci libpci-dev )

add_available_ubuntu_package(jansson libjansson-dev)
add_available_ubuntu_package(libdbus-glib-1-dev libdbus-glib-1-dev)

add_available_ubuntu_package(libdbus-c++-dev libdbus-c++-dev)

add_available_ubuntu_package(libpulse libpulse-dev)

add_available_ubuntu_package(lxc lxc-dev)

add_available_ubuntu_package(x11libs "^libxcb.* libx11-xcb-dev libxrender-dev libxi-dev")

add_available_ubuntu_package(opengl-libs libglu1-mesa-dev)

add_available_ubuntu_package(gstreamer libgstreamer1.0-dev)


set(DEPENDENCIES_MESSAGE "\n\nIn order to get all the dependencies installed on your system, you can use the following command:\n $ sudo apt-get install ${REQUIRED_DEBIAN_PACKAGES}\n\n")
file(WRITE ${PROJECT_BINARY_DIR}/debian_packages "${DEPENDENCIES_MESSAGE}")

add_custom_target(show_dependencies
                  COMMAND cat ${PROJECT_BINARY_DIR}/debian_packages
)

message(${DEPENDENCIES_MESSAGE})
