# Generate the GenerateCLPConfig.cmake file in the build tree and configure
# one the installation tree.

# Settings specific to build trees
#
#
set(GenerateCLP_USE_FILE_CONFIG ${GenerateCLP_BINARY_DIR}/UseGenerateCLP.cmake)
configure_file(${GenerateCLP_SOURCE_DIR}/UseGenerateCLP.cmake.in
  ${GenerateCLP_USE_FILE_CONFIG}
  @ONLY)

set(GenerateCLP_INCLUDE_DIRS_CONFIG ${GenerateCLP_INCLUDE_DIRS})
set(GenerateCLP_LIBRARY_DIRS_CONFIG
  ${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}
  ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}
  )
set(GenerateCLP_CMAKE_DIR_CONFIG ${GenerateCLP_BINARY_DIR})
set(GenerateCLP_CONFIG_DIR "${GenerateCLP_BINARY_DIR}")
set(ITK_DIR_CONFIG ${ITK_DIR})
configure_file(${GenerateCLP_SOURCE_DIR}/GenerateCLPConfig.cmake.in
  ${GenerateCLP_BINARY_DIR}/GenerateCLPConfig.cmake @ONLY)


# Configure GenerateCLPConfig.cmake for the install tree.
file(RELATIVE_PATH GenerateCLP_CONFIG_TO_PREFIX "/prefix/${GenerateCLP_INSTALL_CONFIG_DIR}" "/prefix")
if(NOT DEFINED ModuleDescriptionParser_INSTALL_CONFIG_DIR)
  set(ModuleDescriptionParser_INSTALL_CONFIG_DIR ${CMAKE_INSTALL_LIBDIR}/cmake/ModuleDescriptionParser)
endif()
if(NOT DEFINED TCLAP_INSTALL_CONFIG_DIR)
  set(TCLAP_INSTALL_CONFIG_DIR ${CMAKE_INSTALL_LIBDIR}/cmake/tclap)
endif()
set(ModuleDescriptionParser_INSTALL_LIB_DIR_CONFIG ${ModuleDescriptionParser_INSTALL_LIB_DIR})
set(ModuleDescriptionParser_INSTALL_CONFIG_DIR_CONFIG ${ModuleDescriptionParser_INSTALL_CONFIG_DIR})
set(TCLAP_INSTALL_CONFIG_DIR_CONFIG ${TCLAP_INSTALL_CONFIG_DIR})
configure_file(${GenerateCLP_SOURCE_DIR}/GenerateCLPInstallConfig.cmake.in
  ${GenerateCLP_BINARY_DIR}/install/GenerateCLPConfig.cmake @ONLY)
