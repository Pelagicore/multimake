add_custom_target(check_@TARGET_NAME@ ALL
    WORKING_DIRECTORY @REPOSITORY_FOLDER@
    COMMAND git log -1 . > ${CMAKE_BINARY_DIR}/Actual@TARGET_NAME@.gitlog
    COMMAND diff ${CMAKE_BINARY_DIR}/Actual@TARGET_NAME@.gitlog @UP_TO_DATE_CHECK_PATH@/@TARGET_NAME@.gitlog
)

#add_custom_target(check_@TARGET_NAME@_deps )
#add_dependencies(check_@TARGET_NAME@_deps _check_dummy @DEPENDENCIES@)
