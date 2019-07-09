
#
# Configure Test Prerequisites
#
configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/CMake/GenerateCLPTestPrerequisites.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/CMake/GenerateCLPTestPrerequisites.cmake
  @ONLY
  )

#
# Add test installing GenerateCLP
#

set(GenerateCLPTest_INSTALL_PREFIX ${CMAKE_CURRENT_BINARY_DIR}/GenerateCLP-install)

if(CMAKE_CONFIGURATION_TYPES)
  set(_build_type ${CMAKE_CFG_INTDIR})
else()
  set(_build_type ${CMAKE_BUILD_TYPE})
endif()
add_test(NAME GenerateCLP-Install
  COMMAND ${CMAKE_COMMAND}
    -DBUILD_TESTING:BOOL=OFF
    -DCMAKE_BUILD_TYPE:STRING=${_build_type}
    -DCMAKE_GENERATOR:STRING=${CMAKE_GENERATOR}
    -DModuleDescriptionParser_DIR:PATH=${ModuleDescriptionParser_BINARY_DIR}
    -DTCLAP_DIR:PATH=${TCLAP_BINARY_DIR}
    -DTEST_CMAKE_DIR:PATH=${GenerateCLP_SOURCE_DIR}/Testing/CMake
    -DTEST_BINARY_DIR:PATH=${CMAKE_CURRENT_BINARY_DIR}/GenerateCLP-build
    -DTEST_INSTALL_DIR:PATH=${GenerateCLPTest_INSTALL_PREFIX}
    -DTEST_SOURCE_DIR:PATH=${GenerateCLP_SOURCE_DIR}
    -P ${CMAKE_CURRENT_SOURCE_DIR}/CMake/GenerateCLP-Install.cmake)
set_property(TEST GenerateCLP-Install PROPERTY LABELS ${PROJECT_NAME})

#
# Helper macro
#
set(_previous_test "NODEPENDS")
macro(generateclp_add_test cliname stepname)

  macro(_generateclp_add_tree_test treetype)
    set(testname GenerateCLPTest-${treetype}-${cliname}-${stepname})
    set(_test_args
      -DTEST_TREETYPE:STRING=${treetype}
      -DTEST_SOURCE_DIR:PATH=${CMAKE_CURRENT_SOURCE_DIR}/${cliname}
      -DTEST_BINARY_DIR:PATH=${CMAKE_CURRENT_BINARY_DIR}/${treetype}-${cliname}
      -DTEST_CONFIGURATION:STRING=$<CONFIGURATION>
      )
    if("${treetype}" STREQUAL "InstallTree" AND "${stepname}" STREQUAL "Configure")
      list(APPEND _test_args
        -DGenerateCLP_DIR:PATH=${GenerateCLPTest_INSTALL_PREFIX}/lib/GenerateCLP/
        )
    endif()

    add_test(NAME ${testname}
      COMMAND ${CMAKE_COMMAND} ${_test_args}
      -P ${CMAKE_CURRENT_SOURCE_DIR}/CMake/GenerateCLPTest-${stepname}.cmake)
    if(NOT ${_previous_test} STREQUAL "NODEPENDS")
      set_tests_properties(${testname} PROPERTIES DEPENDS ${_previous_test})
    endif()
    set(_previous_test ${testname})
    set_property(TEST ${testname} PROPERTY LABELS ${PROJECT_NAME})
  endmacro()

  # Build and install cases
  _generateclp_add_tree_test(BuildTree)
  _generateclp_add_tree_test(InstallTree)
  if(stepname STREQUAL "Configure")
    # Install case required GenerareCLP install tree
    set_tests_properties(${testname} PROPERTIES DEPENDS GenerateCLP-Install)
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
