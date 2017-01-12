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

macro(add_maven_external_project PROJECT PATH DEPENDENCIES CONFIGURATION_OPTIONS)

    set_package_defined(${PROJECT})
    add_dependencies_target(${PROJECT} "${DEPENDENCIES}")
    
    read_common_properties(${PROJECT})
    
    ExternalProject_Add(${PROJECT}
        DEPENDS ${DEPENDENCIES}
        SOURCE_DIR ${PATH}
        PREFIX ${PROJECT}
        ${${PROJECT}_BUILD_ALWAYS_OPTION}
        DOWNLOAD_COMMAND ""
        UPDATE_COMMAND ""
        INSTALL_COMMAND ""
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
    )
    
    ExternalProject_Add_Step(${PROJECT} installd
        COMMAND ${SET_ENV} mvn install ${MAVEN_OPTIONS}
        DEPENDEES configure
        WORKING_DIRECTORY <SOURCE_DIR>
        ALWAYS 0
    )
      
    write_variables_file()

endmacro()


macro(add_maven_external_git_project PROJECT REPOSITORY_URL DEPENDENCIES CONFIGURATION_OPTIONS)
    
    validate_git_commit(${PROJECT})
    read_common_properties(${PROJECT})

    if(NOT ${PROJECT}_DEFINED)
        
        set_package_defined_with_git_repository(${PROJECT})
        
        add_dependencies_target(${PROJECT} "${DEPENDENCIES}")
        
        set(SOURCE_DIR ${PROJECTS_DOWNLOAD_DIR}/${PROJECT})
        
        ExternalProject_Add(${PROJECT}
            DEPENDS ${DEPENDENCIES}
            SOURCE_DIR ${SOURCE_DIR}
            GIT_REPOSITORY ${REPOSITORY_URL}
            PREFIX ${PROJECT}
            ${${PROJECT}_BUILD_ALWAYS_OPTION}
            #    DOWNLOAD_COMMAND ""
            UPDATE_COMMAND ""
            INSTALL_COMMAND ""
            CONFIGURE_COMMAND ""
            BUILD_COMMAND ""
            GIT_TAG ${${PROJECT}_GIT_COMMIT}
        )
        
        ExternalProject_Add_Step(${PROJECT} installd
            COMMAND ${SET_ENV} mvn install ${MAVEN_OPTIONS}
            DEPENDEES configure
            WORKING_DIRECTORY ${SOURCE_DIR}/${PATH}
            ALWAYS 0
        )
          
        write_variables_file()
        init_repository(${PROJECT})
        
    endif()
    
endmacro()
