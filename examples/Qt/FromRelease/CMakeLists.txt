cmake_minimum_required(VERSION 2.6)

project(BuildQtPackages)

find_package(Multimake REQUIRED HINTS ${CMAKE_CURRENT_SOURCE_DIR}/../../..)

set(qt_GIT_COMMIT v5.9.1)
set(QT_MODULES_LIST "--module-subset=qtbase,qtdeclarative,qtmultimedia,qtgraphicaleffects,qtquickcontrols,qttools,qtimageformats,qtserialport")
add_qt_external_tgz_project(qt qt "https://download.qt.io/archive/qt/5.9/5.9.1/single/qt-everywhere-opensource-src-5.9.1.tar.xz" "" "${QT_MODULES_LIST}" "-verbose")

set(gammaray_GIT_COMMIT 79aff446d0274563b56569c76a57dfd940edcc9e)
add_cmake_external_git_project(gammaray "https://github.com/KDAB/GammaRay.git" "qt" "" "")

set(appman_GIT_COMMIT 5.9)
#add_qmake_external_git_project(appman "https://code.qt.io/qt/qtapplicationmanager.git" "qt" "" "")
