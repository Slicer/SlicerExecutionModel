# Generate the SlicerExecutionModelConfig.cmake file in the build tree
# and configure one in the installation tree.

# Settings specific to build trees
#
#

set(SlicerExecutionModel_INCLUDE_DIRS_CONFIG ${SlicerExecutionModel_INCLUDE_DIRS})

set(SlicerExecutionModel_LIBRARIES_CONFIG ModuleDescriptionParser)
if(SlicerExecutionModel_USE_JSONCPP)
  set(DEFAULT_SEM_TARGET_LIBRARIES_CONFIG ${JsonCpp_LIBRARIES})
endif()

set(SlicerExecutionModel_USE_FILE_CONFIG
  ${SlicerExecutionModel_BINARY_DIR}/UseSlicerExecutionModel.cmake)

set(SlicerExecutionModel_DEFAULT_CLI_RUNTIME_OUTPUT_DIRECTORY_CONFIG
  ${SlicerExecutionModel_DEFAULT_CLI_RUNTIME_OUTPUT_DIRECTORY}
  )
set(SlicerExecutionModel_DEFAULT_CLI_LIBRARY_OUTPUT_DIRECTORY_CONFIG
  ${SlicerExecutionModel_DEFAULT_CLI_LIBRARY_OUTPUT_DIRECTORY}
  )
set(SlicerExecutionModel_DEFAULT_CLI_ARCHIVE_OUTPUT_DIRECTORY_CONFIG
  ${SlicerExecutionModel_DEFAULT_CLI_ARCHIVE_OUTPUT_DIRECTORY}
  )

set(SlicerExecutionModel_DEFAULT_CLI_INSTALL_RUNTIME_DESTINATION_CONFIG
  ${SlicerExecutionModel_DEFAULT_CLI_INSTALL_RUNTIME_DESTINATION}
  )
set(SlicerExecutionModel_DEFAULT_CLI_INSTALL_LIBRARY_DESTINATION_CONFIG
  ${SlicerExecutionModel_DEFAULT_CLI_INSTALL_LIBRARY_DESTINATION}
  )
set(SlicerExecutionModel_DEFAULT_CLI_INSTALL_ARCHIVE_DESTINATION_CONFIG
  ${SlicerExecutionModel_DEFAULT_CLI_INSTALL_ARCHIVE_DESTINATION}
  )

set(SlicerExecutionModel_DEFAULT_CLI_TARGETS_FOLDER_PREFIX_CONFIG
  ${SlicerExecutionModel_DEFAULT_CLI_TARGETS_FOLDER_PREFIX}
  )

set(SlicerExecutionModel_LIBRARY_DIRS_CONFIG
  ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}
  ${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}
  )

set(SlicerExecutionModel_DEFAULT_CLI_LIBRARY_WRAPPER_CXX_CONFIG
  ${SlicerExecutionModel_DEFAULT_CLI_LIBRARY_WRAPPER_CXX}
  )

set(SlicerExecutionModel_CMAKE_DIR_CONFIG "\${SlicerExecutionModel_DIR}/CMake")
set(SlicerExecutionModel_EXPORT_FILE_CONFIG ${SlicerExecutionModel_EXPORT_FILE})
set(ModuleDescriptionParser_DIR_CONFIG "\${SlicerExecutionModel_DIR}/ModuleDescriptionParser")
set(GenerateCLP_DIR_CONFIG "\${SlicerExecutionModel_DIR}/GenerateCLP")
set(TCLAP_DIR_CONFIG "\${SlicerExecutionModel_DIR}/tclap")

# Configure SlicerExecutionModelConfig.cmake for the build tree.
#
configure_file(
  ${SlicerExecutionModel_SOURCE_DIR}/SlicerExecutionModelConfig.cmake.in
  ${SlicerExecutionModel_BINARY_DIR}/SlicerExecutionModelConfig.cmake
  @ONLY
  )

# Settings specific for installation trees
#
#
if(NOT SlicerExecutionModel_INSTALL_DEVELOPMENT)
  return()
endif()

file(RELATIVE_PATH _sem_config_to_prefix
  "/prefix/${SlicerExecutionModel_INSTALL_CONFIG_DIR}" "/prefix")
string(REGEX REPLACE "/$" "" _sem_config_to_prefix "${_sem_config_to_prefix}")
set(_sem_prefix "\${SlicerExecutionModel_CONFIG_DIR}/${_sem_config_to_prefix}")

set(_sem_mdp_lib_dir lib/ModuleDescriptionParser)
if(DEFINED ModuleDescriptionParser_INSTALL_LIB_DIR)
  set(_sem_mdp_lib_dir ${ModuleDescriptionParser_INSTALL_LIB_DIR})
endif()

set(SlicerExecutionModel_INCLUDE_DIRS_CONFIG
  "${_sem_prefix}/include/ModuleDescriptionParser"
  "${_sem_prefix}/include"
  ${_additional_include_dirs}
  )
set(SlicerExecutionModel_USE_FILE_CONFIG
  "\${SlicerExecutionModel_CONFIG_DIR}/UseSlicerExecutionModel.cmake")
set(SlicerExecutionModel_CMAKE_DIR_CONFIG "\${SlicerExecutionModel_CONFIG_DIR}/CMake")
set(SlicerExecutionModel_LIBRARY_DIRS_CONFIG "${_sem_prefix}/${_sem_mdp_lib_dir}")
set(SlicerExecutionModel_DEFAULT_CLI_LIBRARY_WRAPPER_CXX_CONFIG
  "\${SlicerExecutionModel_CMAKE_DIR}/SEMCommandLineLibraryWrapper.cxx")
set(SlicerExecutionModel_EXPORT_FILE_CONFIG "")
set(ModuleDescriptionParser_DIR_CONFIG "${_sem_prefix}/lib/ModuleDescriptionParser")
set(GenerateCLP_DIR_CONFIG "${_sem_prefix}/lib/GenerateCLP")
set(TCLAP_DIR_CONFIG "${_sem_prefix}/lib/tclap")

configure_file(
  ${SlicerExecutionModel_SOURCE_DIR}/SlicerExecutionModelConfig.cmake.in
  ${SlicerExecutionModel_BINARY_DIR}/install/SlicerExecutionModelConfig.cmake
  @ONLY
  )
