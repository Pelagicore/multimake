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

find_package(Multimake)

add_cmake_external_git_project(dlt "https://github.com/Pelagicore/dlt.git" "zlib" "" )

add_cmake_external_git_project(ivi-logging "https://github.com/Pelagicore/ivi-logging.git" "dlt" "" )

add_cmake_external_git_project(ivi-main-loop "https://github.com/Pelagicore/MainLoop.git" "" "" )
