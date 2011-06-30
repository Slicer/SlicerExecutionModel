# Generate the SlicerExecutionModelConfig.cmake file in the build tree
# and configure one in the installation tree.

# Settings specific to build trees
#
#

set(SlicerExecutionModel_LIBRARIES_CONFIG ModuleDescriptionParser)

set(SlicerExecutionModel_USE_FILE_CONFIG
  ${SlicerExecutionModel_BINARY_DIR}/UseSlicerExecutionModel.cmake)

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
