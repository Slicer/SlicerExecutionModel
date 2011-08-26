# Generate the SlicerExecutionModelConfig.cmake file in the build tree
# and configure one in the installation tree.

# Settings specific to build trees
#
#

set(SlicerExecutionModel_INCLUDE_DIRS_CONFIG ${SlicerExecutionModel_INCLUDE_DIRS})

set(SlicerExecutionModel_LIBRARIES_CONFIG ModuleDescriptionParser)

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

# TODO - Configure SlicerExecutionModelConfig.cmake for the install tree.
#
#configure_file(
#  ${SlicerExecutionModel_SOURCE_DIR}/SlicerExecutionModelInstallConfig.cmake.in
#  ${SlicerExecutionModel_BINARY_DIR}/install/SlicerExecutionModelConfig.cmake
#  @ONLY
#  )
