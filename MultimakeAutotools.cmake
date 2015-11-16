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

# Some broken packages assume that they are going to find some required headers in standard locations such as "/usr/include" instead of using pkg-config to locate those
# headers. As a workaround, we add the "${CMAKE_INSTALL_PREFIX}/include" folder as an include folder.
set(AUTOTOOLS_DEFAULT_MAKE_OPTIONS "${AUTOTOOLS_DEFAULT_MAKE_OPTIONS};CFLAGS=-I${CMAKE_INSTALL_PREFIX}/include")

macro(add_autotools_external_project PROJECT PATH DEPENDENCIES CONFIGURATION_OPTIONS)

    set_package_defined(${PROJECT})
    set(CONFIGURE_COMMAND ${PROJECTS_LOCATION}/${PATH}/${AUTOTOOLS_CONFIGURE_COMMAND} ${CONFIGURATION_OPTIONS})
    add_dependencies_target(${PROJECT} "${DEPENDENCIES}")

    read_common_properties(${PROJECT})

    if (NOT ${PROJECT}_IN_SOURCE_BUILD)

        ExternalProject_Add(${PROJECT}
            DEPENDS ${DEPENDENCIES}
            SOURCE_DIR ${PROJECTS_LOCATION}/${PATH}
            DOWNLOAD_COMMAND ""
            PREFIX ${PROJECT}
            ${BUILD_ALWAYS}
            ${INSTALL_COMMAND}
            CONFIGURE_COMMAND ""
            BUILD_COMMAND ${CONFIGURE_COMMAND} && $(MAKE) ${AUTOTOOLS_DEFAULT_MAKE_OPTIONS}
        )

    else()

        ExternalProject_Add(${PROJECT}
            DEPENDS ${DEPENDENCIES}
            SOURCE_DIR ${PROJECTS_LOCATION}/${PATH}
            BINARY_DIR ${PROJECTS_LOCATION}/${PATH}
            PREFIX ${PROJECT}
            ${BUILD_ALWAYS}
            DOWNLOAD_COMMAND ""
            ${INSTALL_COMMAND}
            CONFIGURE_COMMAND ""
            BUILD_COMMAND ${CONFIGURE_COMMAND} && $(MAKE) ${AUTOTOOLS_DEFAULT_MAKE_OPTIONS}
        )

    endif()

    ExternalProject_Add_Step(${PROJECT} autoreconf_step
        COMMAND autoreconf -i
        DEPENDEES configure
        DEPENDERS build
        WORKING_DIRECTORY <SOURCE_DIR>
        ALWAYS 0
    )

    write_variables_file()

endmacro()


macro(add_autotools_external_git_project PROJECT PATH REPOSITORY_URL DEPENDENCIES CONFIGURATION_OPTIONS)

    validate_git_commit(${PROJECT})
    read_common_properties(${PROJECT})
    
    if(NOT ${PROJECT}_DEFINED)
    
        set_package_defined_with_git_repository(${PROJECT})
        set(CONFIGURE_COMMAND ${PROJECTS_DOWNLOAD_DIR}/${PATH}/${AUTOTOOLS_CONFIGURE_COMMAND} ${CONFIGURATION_OPTIONS})
        add_dependencies_target(${PROJECT} "${DEPENDENCIES}")

        if(NOT ${PROJECT}_IN_SOURCE_BUILD)
        
            ExternalProject_Add(${PROJECT}
                DEPENDS ${DEPENDENCIES}
                SOURCE_DIR ${PROJECTS_DOWNLOAD_DIR}/${PATH}
                PREFIX ${PROJECT}
                ${BUILD_ALWAYS}
                GIT_REPOSITORY ${REPOSITORY_URL}
                ${INSTALL_COMMAND}
                CONFIGURE_COMMAND ""
                BUILD_COMMAND $(MAKE) ${AUTOTOOLS_DEFAULT_MAKE_OPTIONS}
                GIT_TAG ${${PROJECT}_GIT_COMMIT}
            )
            
        else()
            
            ExternalProject_Add(${PROJECT}
                DEPENDS ${DEPENDENCIES}
                SOURCE_DIR ${PROJECTS_DOWNLOAD_DIR}/${PATH}
                BINARY_DIR ${PROJECTS_DOWNLOAD_DIR}/${PATH}
                PREFIX ${PROJECT}
                ${BUILD_ALWAYS}
                GIT_REPOSITORY ${REPOSITORY_URL}
                ${INSTALL_COMMAND}
                CONFIGURE_COMMAND ""
                BUILD_COMMAND $(MAKE) ${AUTOTOOLS_DEFAULT_MAKE_OPTIONS}
                GIT_TAG ${${PROJECT}_GIT_COMMIT}
            )
        
        endif()
        
        ExternalProject_Add_Step(${PROJECT} configure_step
            COMMAND ${CONFIGURE_COMMAND}
            DEPENDEES configure
            DEPENDERS build
            WORKING_DIRECTORY <BINARY_DIR>
            ALWAYS 0
        )
        
        # We create a link to "install-sh" since that is way to get common-api packages built properly under Debian.
        # TODO : get common-api packages fixed and remove that hack 
        ExternalProject_Add_Step(${PROJECT} autoreconf_step
            COMMAND autoreconf -i
            #    COMMAND ln -f -s build-aux/install-sh install-sh 
            DEPENDEES configure
            DEPENDERS configure_step
            WORKING_DIRECTORY <SOURCE_DIR>
            ALWAYS 0
        )
        
        write_variables_file()
        
    endif()

endmacro()

macro(add_autotools_external_project_badconfigure PROJECT PATH DEPENDENCIES CONFIGURATION_OPTIONS MAKE_OPTIONS)
    
    set_package_defined(${PROJECT})
    set(CONFIGURE_COMMAND ${PROJECTS_LOCATION}/${PATH}/${AUTOTOOLS_CONFIGURE_COMMAND} ${CONFIGURATION_OPTIONS})
    add_dependencies_target(${PROJECT} "${DEPENDENCIES}")
    read_common_properties(${PROJECT})

    if (NOT ${PROJECT}_IN_SOURCE_BUILD)
        
        ExternalProject_Add(${PROJECT}
            DEPENDS ${DEPENDENCIES}
            SOURCE_DIR ${PROJECTS_LOCATION}/${PATH}
            PREFIX ${PROJECT}
            ${BUILD_ALWAYS}
            DOWNLOAD_COMMAND ""
            ${INSTALL_COMMAND}
            CONFIGURE_COMMAND ""
            BUILD_COMMAND ${CONFIGURE_COMMAND} && $(MAKE) ${MAKE_OPTIONS}
        )
        
    else()
    
        ExternalProject_Add(${PROJECT}
            DEPENDS ${DEPENDENCIES}
            SOURCE_DIR ${PROJECTS_LOCATION}/${PATH}
            BINARY_DIR ${PROJECTS_LOCATION}/${PATH}
            PREFIX ${PROJECT}
            ${BUILD_ALWAYS}
            DOWNLOAD_COMMAND ""
            ${INSTALL_COMMAND}
            CONFIGURE_COMMAND ""
            BUILD_COMMAND ${CONFIGURE_COMMAND} && $(MAKE) ${MAKE_OPTIONS}
        )
        
    endif()

    ExternalProject_Add_Step(${PROJECT} autoreconf_step
        COMMAND autoreconf -i
        DEPENDEES configure
        DEPENDERS build
        WORKING_DIRECTORY <SOURCE_DIR>
        ALWAYS 0
    )
    
    write_variables_file()

endmacro()



macro(add_autotools_external_git_project_badconfigure PROJECT PATH REPOSITORY_URL DEPENDENCIES CONFIGURATION_OPTIONS MAKE_OPTIONS)
    
    validate_git_commit(${PROJECT})
    read_common_properties(${PROJECT})

    if(NOT ${PROJECT}_DEFINED)
    
        set_package_defined_with_git_repository(${PROJECT})
        
        set(CONFIGURE_COMMAND ${PROJECTS_DOWNLOAD_DIR}/${PATH}/${AUTOTOOLS_CONFIGURE_COMMAND} ${CONFIGURATION_OPTIONS})
        
        add_dependencies_target(${PROJECT} "${DEPENDENCIES}")
        
        if (NOT ${PROJECT}_IN_SOURCE_BUILD)
        
            ExternalProject_Add(${PROJECT}
                DEPENDS ${DEPENDENCIES}
                SOURCE_DIR ${PROJECTS_DOWNLOAD_DIR}/${PATH}
                PREFIX ${PROJECT}
                ${BUILD_ALWAYS}
                GIT_REPOSITORY ${REPOSITORY_URL}
                ${INSTALL_COMMAND}
                CONFIGURE_COMMAND ""
                BUILD_COMMAND $(MAKE) ${MAKE_OPTIONS}
                GIT_TAG ${${PROJECT}_GIT_COMMIT}
            )
        
        else()
        
            ExternalProject_Add(${PROJECT}
                DEPENDS ${DEPENDENCIES}
                SOURCE_DIR ${PROJECTS_DOWNLOAD_DIR}/${PATH}
                BINARY_DIR ${PROJECTS_DOWNLOAD_DIR}/${PATH}
                PREFIX ${PROJECT}
                ${BUILD_ALWAYS}
                GIT_REPOSITORY ${REPOSITORY_URL}
                ${INSTALL_COMMAND}
                CONFIGURE_COMMAND ""
                BUILD_COMMAND $(MAKE) ${MAKE_OPTIONS}
                GIT_TAG ${${PROJECT}_GIT_COMMIT}
            )

        endif()
        
        ExternalProject_Add_Step(${PROJECT} configure_step
            COMMAND ${CONFIGURE_COMMAND}
            DEPENDEES configure
            DEPENDERS build
            WORKING_DIRECTORY <BINARY_DIR>
            ALWAYS 0
        )
        
        # We create a link to "install-sh" since that is way to get common-api packages built properly under Debian.
        # TODO : get common-api packages fixed and remove that hack 
        ExternalProject_Add_Step(${PROJECT} autoreconf_step
            COMMAND autoreconf -i
            DEPENDEES configure
            DEPENDERS configure_step
            WORKING_DIRECTORY <SOURCE_DIR>
            ALWAYS 0
        )
        
        write_variables_file()

    endif()

endmacro()
