
#
# Configure Test Prerequisites
#
configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/CMake/GenerateCLPTestPrerequisites.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/CMake/GenerateCLPTestPrerequisites.cmake
  @ONLY
  )

#
# Install SlicerExecutionModel into a test prefix
#
set(_test_install_tree OFF)
if(SlicerExecutionModel_INSTALL_DEVELOPMENT AND DEFINED SlicerExecutionModel_BINARY_DIR)
  set(_test_install_tree ON)
  set(_test_install_dir ${CMAKE_CURRENT_BINARY_DIR}/SlicerExecutionModel-install)
  add_test(NAME SlicerExecutionModel-Install
    COMMAND ${CMAKE_COMMAND}
    -DSEM_BINARY_DIR:PATH=${SlicerExecutionModel_BINARY_DIR}
    -DTEST_INSTALL_DIR:PATH=${_test_install_dir}
    -DTEST_CONFIGURATION:STRING=$<CONFIG>
    -P ${CMAKE_CURRENT_SOURCE_DIR}/CMake/SlicerExecutionModel-Install.cmake)
  set_tests_properties(SlicerExecutionModel-Install PROPERTIES
    FIXTURES_SETUP SlicerExecutionModelInstallTree
    LABELS ${PROJECT_NAME}
    )
endif()

#
# Helper macro
#
set(_previous_test "NODEPENDS")
macro(generateclp_add_test cliname stepname)
  set(testname GenerateCLPTest-${cliname}-${stepname})
  add_test(NAME ${testname}
    COMMAND ${CMAKE_COMMAND}
    -DTEST_SOURCE_DIR:PATH=${CMAKE_CURRENT_SOURCE_DIR}/${cliname}
    -DTEST_BINARY_DIR:PATH=${CMAKE_CURRENT_BINARY_DIR}/${cliname}
    -DTEST_CONFIGURATION:STRING=$<CONFIGURATION>
    -P ${CMAKE_CURRENT_SOURCE_DIR}/CMake/GenerateCLPTest-${stepname}.cmake)
  if(NOT ${_previous_test} STREQUAL "NODEPENDS")
    set_tests_properties(${testname} PROPERTIES DEPENDS ${_previous_test})
  endif()
  set(_previous_test ${testname})
  set_property(TEST ${testname} PROPERTY LABELS ${PROJECT_NAME})

  if(_test_install_tree)
    set(_install_testname GenerateCLPTest-InstallTree-${cliname}-${stepname})
    add_test(NAME ${_install_testname}
      COMMAND ${CMAKE_COMMAND}
      -DTEST_SOURCE_DIR:PATH=${CMAKE_CURRENT_SOURCE_DIR}/${cliname}
      -DTEST_BINARY_DIR:PATH=${CMAKE_CURRENT_BINARY_DIR}/InstallTree-${cliname}
      -DTEST_CONFIGURATION:STRING=$<CONFIGURATION>
      -DTEST_GenerateCLP_DIR:PATH=${_test_install_dir}/lib/GenerateCLP
      -DTEST_SlicerExecutionModel_DIR:PATH=${_test_install_dir}/${SlicerExecutionModel_INSTALL_CONFIG_DIR}
      -P ${CMAKE_CURRENT_SOURCE_DIR}/CMake/GenerateCLPTest-${stepname}.cmake)
    if(NOT "${stepname}" STREQUAL "Configure")
      set_tests_properties(${_install_testname} PROPERTIES
        DEPENDS ${_previous_install_test})
    endif()
    set(_previous_install_test ${_install_testname})
    set_tests_properties(${_install_testname} PROPERTIES
      FIXTURES_REQUIRED SlicerExecutionModelInstallTree
      LABELS ${PROJECT_NAME}
      )
  endif()
endmacro()

#
# Add Tests
#
set(_previous_test "NODEPENDS")
generateclp_add_test(Slicer3Example Configure)
generateclp_add_test(Slicer3Example Build)
generateclp_add_test(Slicer3Example Test)

set(_previous_test "NODEPENDS")
generateclp_add_test(PointExample1 Configure)
generateclp_add_test(PointExample1 Build)
#generateclp_add_test(PointExample1 Test)

set(_previous_test "NODEPENDS")
generateclp_add_test(CLPExample1 Configure)
generateclp_add_test(CLPExample1 Build)
generateclp_add_test(CLPExample1 Test)

set(_previous_test "NODEPENDS")
generateclp_add_test(CLPTestMultiple Configure)
generateclp_add_test(CLPTestMultiple Build)
generateclp_add_test(CLPTestMultiple Test)

if(SlicerExecutionModel_USE_UTF8)
  set(_previous_test "NODEPENDS")
  generateclp_add_test(Utf8Example Configure)
  generateclp_add_test(Utf8Example Build)
  generateclp_add_test(Utf8Example Test)
endif()

set(_previous_test "NODEPENDS")
generateclp_add_test(SEMMacroBuildCLIExample Configure)
generateclp_add_test(SEMMacroBuildCLIExample Build)
generateclp_add_test(SEMMacroBuildCLIExample Test)
