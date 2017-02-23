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


set(QT_STANDARD_CONFIGURE_PROPERTIES "-opensource;-confirm-license")

if("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
    set(QT_STANDARD_CONFIGURE_PROPERTIES "${QT_STANDARD_CONFIGURE_PROPERTIES};-debug")
    set(QMAKE_COMMON_CONFIGURATION_OPTIONS "CONFIG+=debug")
endif()

macro(read_qmake_properties PROJECT)

    read_common_properties(${PROJECT})
    set(MAKE_COMMAND "$(MAKE)")
    set(DEPLOY_COMMAND ${MAKE_COMMAND} install INSTALL_ROOT=${DEPLOYMENT_PATH})

endmacro()


macro(locate_qt)
    
    if(NOT DEFINED QT_PATH)
        
        execute_process(COMMAND which qmake
            OUTPUT_VARIABLE QT_PATH
            RESULT_VARIABLE RES
        )
        
        if(RES EQUAL 0)
        
            get_filename_component(QT_PATH ${QT_PATH} DIRECTORY)
            get_filename_component(QT_PATH ${QT_PATH} DIRECTORY)
            
            message("Qt installation located in ${QT_PATH} ${RES}")
            
            set(QT_CMAKE_PATH ${QT_PATH}/lib/cmake)
            set(QT_CMAKE_OPTIONS -DCMAKE_PREFIX_PATH=${QT_CMAKE_PATH})
            
        else()
            message( FATAL_ERROR "A \"qmake\" executable could not be found in your $PATH => Unable to build Qt-based packages !") 
        endif()
        
    endif()

endmacro()



macro(add_qmake_external_project PROJECT PATH DEPENDENCIES CONFIGURATION_OPTIONS)

    locate_qt()
    set_package_defined(${PROJECT})
    add_dependencies_target(${PROJECT} "${DEPENDENCIES}")
    read_qmake_properties(${PROJECT})

    set(CONFIGURE_COMMAND ${QT_PATH}/bin/qmake ${PATH} ${QMAKE_COMMON_CONFIGURATION_OPTIONS} ${CONFIGURATION_OPTIONS})

    ExternalProject_Add(${PROJECT}
        DEPENDS ${DEPENDENCIES}
        SOURCE_DIR ${PATH}
        BINARY_DIR ${BINARY_DIR}
        PREFIX ${PROJECT}
        ${${PROJECT}_BUILD_ALWAYS_OPTION}
        DOWNLOAD_COMMAND ""
        UPDATE_COMMAND ""
        ${INSTALL_COMMAND}
        CONFIGURE_COMMAND ${SET_ENV} ${CONFIGURE_COMMAND}
        BUILD_COMMAND ${SET_ENV} $(MAKE)
    )

    init_project(${PROJECT})

    add_deployment_steps(${PROJECT} "${DEPLOY_COMMAND}")

    write_variables_file()

endmacro()



macro(add_qmake_external_git_project PROJECT REPOSITORY_URL DEPENDENCIES CONFIGURATION_OPTIONS)

    locate_qt()
    validate_git_commit(${PROJECT})
    read_qmake_properties(${PROJECT})
    
    if(NOT ${PROJECT}_DEFINED)
    
        set_package_defined_with_git_repository(${PROJECT})
        add_dependencies_target(${PROJECT} "${DEPENDENCIES}")
        
        set(CONFIGURE_COMMAND ${QT_PATH}/bin/qmake ${PROJECTS_DOWNLOAD_DIR}/${PATH} ${QMAKE_COMMON_CONFIGURATION_OPTIONS} ${CONFIGURATION_OPTIONS})
        
        ExternalProject_Add(${PROJECT}
            DEPENDS ${DEPENDENCIES}
            SOURCE_DIR ${PROJECTS_DOWNLOAD_DIR}/${PATH}
            BINARY_DIR ${BINARY_DIR}
            PREFIX ${PROJECT}
            ${${PROJECT}_BUILD_ALWAYS_OPTION}
            GIT_REPOSITORY ${REPOSITORY_URL}
            UPDATE_COMMAND  ""
            ${INSTALL_COMMAND}
            CONFIGURE_COMMAND ${SET_ENV} ${CONFIGURE_COMMAND}
            BUILD_COMMAND ${SET_ENV} $(MAKE)
            GIT_TAG ${${PROJECT}_GIT_COMMIT}
        )

        init_repository(${PROJECT})
        init_project(${PROJECT})

        add_deployment_steps(${PROJECT} "${DEPLOY_COMMAND}")

        write_variables_file()
    else()
        on_package_already_defined(${PROJECT})
    endif()

endmacro()


macro(add_qt_external_tgz_project PROJECT PATH REPOSITORY_URL DEPENDENCIES INIT_REPOSITORY_OPTIONS CONFIGURATION_OPTIONS)
    
    read_common_properties(${PROJECT})
    
    if(NOT ${PROJECT}_DEFINED)
    
        # We build Qt ourselves => point to that Qt to build other packages
        set(QT_PATH ${${PROJECT}_INSTALL_PREFIX})
        
        set_package_defined(${PROJECT})

        add_dependencies_target(${PROJECT} "${DEPENDENCIES}")

        set(CONFIGURE_CMD configure "${QT_STANDARD_CONFIGURE_PROPERTIES};${CONFIGURATION_OPTIONS}" )

        ExternalProject_Add(${PROJECT}
            DEPENDS ${DEPENDENCIES}
            PREFIX ${PROJECT}
            ${${PROJECT}_BUILD_ALWAYS_OPTION}
            SOURCE_DIR ${PROJECTS_DOWNLOAD_DIR}/${PATH}
            BINARY_DIR ${PROJECTS_DOWNLOAD_DIR}/${PATH}
            URL ${REPOSITORY_URL}
            UPDATE_COMMAND ""
            ${INSTALL_COMMAND}
            CONFIGURE_COMMAND ${SET_ENV} <SOURCE_DIR>/${CONFIGURE_CMD}
            BUILD_COMMAND ${SET_ENV} $(MAKE)
        )
        
        add_deployment_steps(${PROJECT} "$(MAKE);install;INSTALL_ROOT=${DEPLOYMENT_PATH}")
        
        write_variables_file()
    
    endif()
    
endmacro()


macro(add_qt_external_git_project PROJECT REPOSITORY_URL DEPENDENCIES INIT_REPOSITORY_OPTIONS CONFIGURATION_OPTIONS)

    validate_git_commit(${PROJECT})
    read_common_properties(${PROJECT})

    if(NOT ${PROJECT}_DEFINED)

        # We build Qt ourselves => point to that Qt to build other packages
        set(QT_PATH ${${PROJECT}_INSTALL_PREFIX})

        set_package_defined_with_git_repository(${PROJECT})

        add_dependencies_target(${PROJECT} "${DEPENDENCIES}")

        set(CONFIGURE_CMD configure "${QT_STANDARD_CONFIGURE_PROPERTIES};${CONFIGURATION_OPTIONS}" )

        ExternalProject_Add(${PROJECT}
            DEPENDS ${DEPENDENCIES}
            SOURCE_DIR ${PROJECTS_DOWNLOAD_DIR}/${PATH}
            BINARY_DIR ${BINARY_DIR}
            GIT_REPOSITORY ${REPOSITORY_URL}
            PREFIX ${PROJECT}
            ${${PROJECT}_BUILD_ALWAYS_OPTION}
            UPDATE_COMMAND ""
            ${INSTALL_COMMAND}
            CONFIGURE_COMMAND ${SET_ENV} <SOURCE_DIR>/${CONFIGURE_CMD}
            BUILD_COMMAND ${SET_ENV} $(MAKE)
            GIT_TAG ${${PROJECT}_GIT_COMMIT}
            GIT_SUBMODULES qtbase    # so that only qtbase submodule is cloned here
        )

        # Add the specific init_repository step before "configure" step
        ExternalProject_Add_Step(${PROJECT} init_repository
            COMMAND ${SET_ENV} init-repository -f ${INIT_REPOSITORY_OPTIONS}
            DEPENDEES update
            DEPENDERS configure
            WORKING_DIRECTORY <SOURCE_DIR>
            ALWAYS 0
        )

        set(${PROJECT}_init_repository_step_defined 1)
        init_repository(${PROJECT})
        init_project(${PROJECT})

        add_deployment_steps(${PROJECT} "$(MAKE);install;INSTALL_ROOT=${DEPLOYMENT_PATH}")

        write_variables_file()

    endif()

endmacro()
