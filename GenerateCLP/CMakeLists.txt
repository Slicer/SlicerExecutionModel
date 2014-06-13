project(GenerateCLP)

#-----------------------------------------------------------------------------
cmake_minimum_required(VERSION 2.8.2)
#-----------------------------------------------------------------------------

#-----------------------------------------------------------------------------
# See http://cmake.org/cmake/help/cmake-2-8-docs.html#section_Policies for details
#-----------------------------------------------------------------------------
if(POLICY CMP0016)
  cmake_policy(SET CMP0016 NEW)
endif()
if(POLICY CMP0017)
  cmake_policy(SET CMP0017 OLD)
endif()

# --------------------------------------------------------------------------
# Prerequisites
# --------------------------------------------------------------------------
find_package(ModuleDescriptionParser REQUIRED)
include(${ModuleDescriptionParser_USE_FILE})

find_package(TCLAP REQUIRED)
include(${TCLAP_USE_FILE})

find_package(ITK REQUIRED)
include(${ITK_USE_FILE})

# --------------------------------------------------------------------------
# Option(s)
# --------------------------------------------------------------------------
if(NOT DEFINED BUILD_SHARED_LIBS)
  option(BUILD_SHARED_LIBS "Build with shared libraries." ON)
endif()
if(NOT DEFINED GENERATECLP_USE_MD5)
  option(GENERATECLP_USE_MD5 "Enabling that option will teach GenerateCLP to overwrite output file only if needed. Make sure to build ITK with KWSYS_USE_MD5 enabled." OFF)
endif()
if(NOT DEFINED GenerateCLP_USE_JSONCPP)
  option(GenerateCLP_USE_JSONCPP "Automatic flags are added to serialize and deserialized the parameters." OFF)
  mark_as_advanced(GenerateCLP_USE_JSONCPP)
endif()
if(NOT DEFINED GenerateCLP_USE_SERIALIZER)
  option(GenerateCLP_USE_SERIALIZER "Automatic flags are added to dump the json-ld schema for the parameters." OFF)
  mark_as_advanced(GenerateCLP_USE_SERIALIZER)
endif()
if(GenerateCLP_USE_SERIALIZER)
  if(NOT ModuleDescriptionParser_USE_SERIALIZER)
    message(SEND_ERROR "ModuleDescriptionParser_USE_SERIALIZER must be ON if GenerateCLP_USE_SERIALIZER is ON.")
  endif()
  include_directories(${ParameterSerializer_INCLUDE_DIRS})
endif()

#-----------------------------------------------------------------------------
# Testing
#-----------------------------------------------------------------------------
include(CTest)

#-----------------------------------------------------------------------------
# Output directories.
#-----------------------------------------------------------------------------
foreach(type LIBRARY RUNTIME ARCHIVE)
  # Make sure the directory exists
  if(DEFINED GenerateCLP_CMAKE_${type}_OUTPUT_DIRECTORY
     AND NOT EXISTS ${GenerateCLP_CMAKE_${type}_OUTPUT_DIRECTORY})
    message(FATAL_ERROR "GenerateCLP_CMAKE_${type}_OUTPUT_DIRECTORY is set to a non-existing directory [${GenerateCLP_CMAKE_${type}_OUTPUT_DIRECTORY}]")
  endif()

  if(NOT DEFINED GenerateCLP_CMAKE_${type}_OUTPUT_DIRECTORY)
    set(GenerateCLP_CMAKE_${type}_OUTPUT_DIRECTORY ${GenerateCLP_BINARY_DIR}/bin)
  endif()
  set(CMAKE_${type}_OUTPUT_DIRECTORY ${GenerateCLP_CMAKE_${type}_OUTPUT_DIRECTORY} CACHE INTERNAL "Single output directory for building all libraries.")
endforeach()

# --------------------------------------------------------------------------
# Configure header(s)
# --------------------------------------------------------------------------
configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/GenerateCLPConfig.h.in
  ${CMAKE_CURRENT_BINARY_DIR}/GenerateCLPConfig.h
  )

include_directories(
  ${CMAKE_CURRENT_BINARY_DIR}
  )

# --------------------------------------------------------------------------
# List of targets to export
# --------------------------------------------------------------------------
set(targets_to_export)

# --------------------------------------------------------------------------
# Build executable
# --------------------------------------------------------------------------
set(executable_name GenerateCLP)
set(GENERATECLP_SOURCE
  GenerateCLP.cxx
  )
add_executable(${executable_name} ${GENERATECLP_SOURCE})
list(APPEND targets_to_export ${executable_name})

target_link_libraries(${executable_name}
  # Appearently windows does not like static libs mixed with shared libs ModuleDescriptionParser-static
  # A different solution will have to be investigated for makeing GenerateCLP work without
  # shared libs.
  ${ParameterSerializer_LIBRARIES}
  ModuleDescriptionParser
  itksys
  ITKEXPAT)

# --------------------------------------------------------------------------
# Install executable
# --------------------------------------------------------------------------
if(NOT DEFINED GenerateCLP_INSTALL_BIN_DIR)
  set(GenerateCLP_INSTALL_BIN_DIR bin)
endif()
if(NOT DEFINED ${PROJECT_NAME}_INSTALL_NO_DEVELOPMENT)
  set(${PROJECT_NAME}_INSTALL_NO_DEVELOPMENT ON)
endif()
if(NOT ${PROJECT_NAME}_INSTALL_NO_DEVELOPMENT)
  install(TARGETS GenerateCLP RUNTIME
    DESTINATION ${GenerateCLP_INSTALL_BIN_DIR} COMPONENT Development
    )
endif()

# --------------------------------------------------------------------------
# Install support files
# --------------------------------------------------------------------------
if(NOT ${PROJECT_NAME}_INSTALL_NO_DEVELOPMENT)
  install(FILES ${GenerateCLP_BINARY_DIR}/GenerateCLPConfig.cmake_install
    DESTINATION lib/GenerateCLP
    COMPONENT Development
    RENAME GenerateCLPConfig.cmake
    )
  install(FILES ${GenerateCLP_BINARY_DIR}/UseGenerateCLP.cmake_install
    DESTINATION lib/GenerateCLP
    COMPONENT Development
    RENAME UseGenerateCLP.cmake
    )
endif()

# --------------------------------------------------------------------------
# Launcher
# --------------------------------------------------------------------------
# Enable shared link forwarding support if needed.
# This is required so that GenerateCLP can be run from either a build or an installed tree,
# where the binary is actually not in the same directory as the shared
# libraries it depends on.
#
set(GenerateCLP_FORWARD_DIR_BUILD "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
set(GenerateCLP_FORWARD_PATH_BUILD " \\
   \".\" CONFIG_DIR_POST, \\
   \"${ITK_DIR}/bin\" CONFIG_DIR_POST, \\
   \"${ModuleDescriptionParser_DIR}/bin\" CONFIG_DIR_POST \\
")
set(GenerateCLP_FORWARD_PATH_INSTALL " \\
   \".\", \\
   \"${ITK_DIR}/bin\", \\
   \"${ModuleDescriptionParser_DIR}/bin\" \\
")
set(GenerateCLP_FORWARD_EXE GenerateCLP)
set(GenerateCLP_FORWARD_DIR_INSTALL "..")

# --------------------------------------------------------------------------
# Build launcher
# --------------------------------------------------------------------------
configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/GenerateCLPLauncher.c.in
  ${CMAKE_CURRENT_BINARY_DIR}/GenerateCLPLauncher.c
  @ONLY)
add_executable(GenerateCLPLauncher
  ${CMAKE_CURRENT_BINARY_DIR}/GenerateCLPLauncher.c)
list(APPEND targets_to_export GenerateCLPLauncher)
add_dependencies(GenerateCLPLauncher GenerateCLP)

# --------------------------------------------------------------------------
# Install launcher
# --------------------------------------------------------------------------
if(NOT ${PROJECT_NAME}_INSTALL_NO_DEVELOPMENT)
  install(TARGETS GenerateCLPLauncher RUNTIME
    DESTINATION bin COMPONENT Development
    )
endif()

# --------------------------------------------------------------------------
# Export target
# --------------------------------------------------------------------------
set(${PROJECT_NAME}_TARGETS ${targets_to_export} CACHE INTERNAL "${PROJECT_NAME} targets" FORCE)
export(TARGETS ${targets_to_export} FILE ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Targets.cmake)

# --------------------------------------------------------------------------
# Set INCLUDE_DIRS variable
# --------------------------------------------------------------------------
set(${PROJECT_NAME}_INCLUDE_DIRS ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR}
  CACHE INTERNAL "${PROJECT_NAME} include dirs" FORCE)

# --------------------------------------------------------------------------
# Configure support files
# --------------------------------------------------------------------------  
configure_file(
  GenerateCLP.cmake
  ${CMAKE_CURRENT_BINARY_DIR}/GenerateCLP.cmake
  @ONLY
  )
include(GenerateGenerateCLPConfig.cmake)

# --------------------------------------------------------------------------
# Testing
# --------------------------------------------------------------------------
if(BUILD_TESTING)
  add_subdirectory(Testing)
endif()

