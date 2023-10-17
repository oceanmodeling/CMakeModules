# -*- mode: cmake -*-

#
# PROJ Find Module for UFS
#
# Usage:
#    Control the search through PROJ_ROOT to the PROJ installation prefix.
#
#    This module does not search default paths!
#
#    Following variables are set:
#    PROJ_STATIC_FOUND       (BOOL)       Flag indicating if PROJ static library was found
#    PROJ_SHARED_FOUND       (BOOL)       Flag indicating if PROJ shared library was found
#    PROJ_INCLUDE_DIR        (PATH)       Path to the PROJ include file
#    PROJ_STATIC_LIBRARY_DIR (PATH)       Path to the PROJ static library
#    PROJ_SHARED_LIBRARY_DIR (PATH)       Path to the PROJ shared library
#    PROJ_LIBRARIES          (FILE)       PROJ library
#
# #############################################################################

if(DEFINED ENV{PROJ_ROOT})
  set(PROJ_ROOT "$ENV{PROJ_ROOT}" )
endif()

find_path(PROJ_INCLUDE_DIR
	  NAMES proj.h proj_api.h
	  PATHS ${PROJ_ROOT}
	  PATH_SUFFIXES include
	  NO_DEFAULT_PATH)

find_path(PROJ_STATIC_LIBRARY_DIR
	  libproj.a
	  PATHS "${PROJ_ROOT}"
	  PATH_SUFFIXES lib lib64
	  NO_DEFAULT_PATH)

find_path(PROJ_SHARED_LIBRARY_DIR
          libproj.so
          PATHS "${PROJ_ROOT}"
          PATH_SUFFIXES lib lib64
          NO_DEFAULT_PATH)

if(PROJ_STATIC_LIBRARY_DIR)
  set(PROJ_STATIC_FOUND TRUE)
  set(PROJ_STATIC_LIBRARIES libproj.a)
else()
  set(PROJ_STATIC_FOUND FALSE)
  set(PROJ_STATIC_LIBRARIES PROJ_STATIC_LIBRARIES-NOTFOUND)
endif()

if(PROJ_SHARED_LIBRARY_DIR)
  set(PROJ_SHARED_FOUND TRUE)
  set(PROJ_SHARED_LIBRARIES libproj.so)
else()
  set(PROJ_SHARED_FOUND FALSE)
  set(PROJ_SHARED_LIBRARIES PROJ_SHARED_LIBRARIES-NOTFOUND)
endif()

message(STATUS "[FindPROJ] PROJ_INCLUDE_DIR: ${PROJ_INCLUDE_DIR}")
message(STATUS "[FindPROJ] PROJ_ROOT: ${PROJ_ROOT}")
message(STATUS "[FindPROJ] PROJ_SHARED_LIBRARY_DIR: ${PROJ_SHARED_LIBRARY_DIR}")
message(STATUS "[FindPROJ] PROJ_STATIC_LIBRARY_DIR: ${PROJ_STATIC_LIBRARY_DIR}")
message(STATUS "[FindPROJ] PROJ_SHARED_FOUND: ${PROJ_SHARED_FOUND}")
message(STATUS "[FindPROJ] PROJ_STATIC_FOUND: ${PROJ_STATIC_FOUND}")
message(STATUS "[FindPROJ] PROJ_SHARED_LIBRARIES: ${PROJ_SHARED_LIBRARIES}")
message(STATUS "[FindPROJ] PROJ_STATIC_LIBRARIES: ${PROJ_STATIC_LIBRARIES}")

# if PROJ is found create imported library target
if(PROJ_STATIC_FOUND AND NOT TARGET PROJ_STATIC)
  add_library(PROJ_STATIC INTERFACE IMPORTED)
  set_target_properties(PROJ_STATIC PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${PROJ_INCLUDE_DIR}"
    INTERFACE_LINK_LIBRARIES "${PROJ_STATIC_LIBRARIES}"
    IMPORTED_GLOBAL True)
endif()

if(PROJ_SHARED_FOUND AND NOT TARGET PROJ_SHARED)
  add_library(PROJ_SHARED INTERFACE IMPORTED)
  set_target_properties(PROJ_SHARED PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${PROJ_INCLUDE_DIR}"
    INTERFACE_LINK_LIBRARIES "${PROJ_SHARED_LIBRARIES}"
    IMPORTED_GLOBAL True)
endif()

if (TARGET PROJ_STATIC)
  add_library(PROJ ALIAS PROJ_STATIC)
endif()

if (TARGET PROJ_SHARED)
  add_library(PROJ ALIAS PROJ_SHARED)
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
  ${CMAKE_FIND_PACKAGE_NAME} 
  REQUIRED_VARS
    PROJ_ROOT
    PROJ_INCLUDE_DIR
  HANDLE_COMPONENTS
)
