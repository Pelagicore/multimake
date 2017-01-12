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

macro(add_cmake_external_project PROJECT PATH DEPENDENCIES CONFIGURATION_OPTIONS)

    append_to_variables(${PROJECT})
    add_dependencies_target(${PROJECT} "${DEPENDENCIES}")
    read_common_properties(${PROJECT})

    if(NOT ${PROJECT}_DEFINED)

        set_package_defined(${PROJECT})

        set(CONFIGURATION_OPTIONS_ALL -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} ${CONFIGURATION_OPTIONS} ${COMMON_CMAKE_CONFIGURATION_OPTIONS} ${QT_CMAKE_OPTIONS})

        ExternalProject_Add(${PROJECT}
            DEPENDS ${DEPENDENCIES}
            SOURCE_DIR ${PATH}
            DOWNLOAD_COMMAND ""
            PREFIX ${PROJECT}
            ${${PROJECT}_BUILD_ALWAYS_OPTION}
            ${INSTALL_COMMAND}
            CMAKE_ARGS
            -DCMAKE_INSTALL_PREFIX=${${PROJECT}_INSTALL_PREFIX}
            -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
            ${CONFIGURATION_OPTIONS}
            ${COMMON_CMAKE_CONFIGURATION_OPTIONS}
            ${QT_CMAKE_OPTIONS}
            CONFIGURE_COMMAND ${SET_ENV} cmake ${CONFIGURATION_OPTIONS_ALL} ${PATH}
            BUILD_COMMAND ${SET_ENV} $(MAKE)
        )

    endif()

    write_variables_file()

endmacro()




macro(add_cmake_external_git_project PROJECT REPOSITORY_URL DEPENDENCIES CONFIGURATION_OPTIONS)

    validate_git_commit(${PROJECT})
    read_common_properties(${PROJECT})

    if(NOT ${PROJECT}_DEFINED)

        set_package_defined_with_git_repository(${PROJECT})
        add_dependencies_target(${PROJECT} "${DEPENDENCIES}")
        check_dependencies_existence(${PROJECT} "${DEPENDENCIES}")
        append_to_variables(${PROJECT})

        set(CONFIGURATION_OPTIONS_ALL -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} ${CONFIGURATION_OPTIONS} ${COMMON_CMAKE_CONFIGURATION_OPTIONS} ${QT_CMAKE_OPTIONS}) 

        ExternalProject_Add(${PROJECT}
            DEPENDS ${DEPENDENCIES}
            SOURCE_DIR ${PROJECTS_DOWNLOAD_DIR}/${PROJECT}
            GIT_REPOSITORY ${REPOSITORY_URL}
            PREFIX ${PROJECT}
            ${${PROJECT}_BUILD_ALWAYS_OPTION}
            CMAKE_ARGS
            -DCMAKE_INSTALL_PREFIX=${${PROJECT}_INSTALL_PREFIX}
            -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
            ${CONFIGURATION_OPTIONS}
            ${COMMON_CMAKE_CONFIGURATION_OPTIONS}
            ${QT_CMAKE_OPTIONS}
            CONFIGURE_COMMAND ${SET_ENV} cmake ${CONFIGURATION_OPTIONS_ALL} ${PROJECTS_DOWNLOAD_DIR}/${PATH}
            BUILD_COMMAND ${SET_ENV} $(MAKE)
            ${INSTALL_COMMAND}
            GIT_TAG ${${PROJECT}_GIT_COMMIT}
        )

        write_variables_file()

        init_repository(${PROJECT})

    else()
        on_package_already_defined(${PROJECT})
    endif()

endmacro()
