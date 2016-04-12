
# --------------------------------------------------------------------------
# Sanity checks

foreach(varname
    CMAKE_BUILD_TYPE
    CMAKE_GENERATOR
    ModuleDescriptionParser_DIR
    TCLAP_DIR
    TEST_CMAKE_DIR
    TEST_SOURCE_DIR
    TEST_BINARY_DIR
    TEST_INSTALL_DIR
  )
  if(NOT DEFINED ${varname})
    message(FATAL_ERROR "Variable ${varname} is not DEFINED")
  endif()
endforeach()

include(${TEST_CMAKE_DIR}/GenerateCLPTestMacros.cmake)

# --------------------------------------------------------------------------
# Delete build and install directory if they exists
execute_process(
  COMMAND ${CMAKE_COMMAND} -E remove_directory ${TEST_BINARY_DIR}
  COMMAND ${CMAKE_COMMAND} -E remove_directory ${TEST_INSTALL_DIR}
  )

# --------------------------------------------------------------------------
# Create build and install directories
execute_process(
  COMMAND ${CMAKE_COMMAND} -E make_directory ${TEST_BINARY_DIR}
  COMMAND ${CMAKE_COMMAND} -E make_directory ${TEST_INSTALL_DIR}
  )

# --------------------------------------------------------------------------
# Debug flags - Set to True to display the command as string
set(PRINT_COMMAND 0)

# --------------------------------------------------------------------------
# Configure
set(command ${CMAKE_COMMAND}
  -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
  -DCMAKE_INSTALL_PREFIX:PATH=${TEST_INSTALL_DIR}
  -DModuleDescriptionParser_DIR:PATH=${ModuleDescriptionParser_DIR}
  -DTCLAP_DIR:PATH=${TCLAP_DIR}
  -G ${CMAKE_GENERATOR} ${TEST_SOURCE_DIR})
execute_process(
  COMMAND ${command}
  WORKING_DIRECTORY ${TEST_BINARY_DIR}
  OUTPUT_VARIABLE ov
  RESULT_VARIABLE rv
  )

print_command_as_string("${command}")

if(rv)
  message(FATAL_ERROR "Failed to configure Test:\n${ov}")
endif()

# --------------------------------------------------------------------------
# Build

set(command ${CMAKE_COMMAND} --build ${TEST_BINARY_DIR} --config ${CMAKE_BUILD_TYPE})
execute_process(
  COMMAND ${command}
  WORKING_DIRECTORY ${TEST_BINARY_DIR}
  OUTPUT_VARIABLE ov
  RESULT_VARIABLE rv
  )

print_command_as_string("${command}")

if(rv)
  message(FATAL_ERROR "Failed to build Test:\n${ov}")
endif()

# --------------------------------------------------------------------------
# Install
set(install_target install)
if(WIN32)
  set(install_target INSTALL)
endif()
set(command ${CMAKE_COMMAND} --build ${TEST_BINARY_DIR} --config ${CMAKE_BUILD_TYPE} --target ${install_target})
execute_process(
  COMMAND ${command}
  WORKING_DIRECTORY ${TEST_BINARY_DIR}
  OUTPUT_VARIABLE ov
  RESULT_VARIABLE rv
  )

print_command_as_string("${command}")

if(rv)
  message(FATAL_ERROR "Failed to install Test:\n${ov}")
endif()
