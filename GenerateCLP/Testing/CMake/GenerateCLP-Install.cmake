
# --------------------------------------------------------------------------
# Sanity checks

foreach(varname TEST_CMAKE_DIR TEST_BINARY_DIR TEST_INSTALL_DIR)
  if(NOT DEFINED ${varname})
    message(FATAL_ERROR "Variable ${varname} is not DEFINED")
  endif()
endforeach()

include(${TEST_CMAKE_DIR}/GenerateCLPTestMacros.cmake)

# --------------------------------------------------------------------------
# Delete install directory if it exists
execute_process(
  COMMAND ${CMAKE_COMMAND} -E remove_directory ${TEST_INSTALL_DIR}
  )

# --------------------------------------------------------------------------
# Create install directory
execute_process(
  COMMAND ${CMAKE_COMMAND} -E make_directory ${TEST_INSTALL_DIR}
  )

# --------------------------------------------------------------------------
# Debug flags - Set to True to display the command as string
set(PRINT_COMMAND 0)

# --------------------------------------------------------------------------
# Install
set(install_target install)
if(WIN32)
  set(install_target INSTALL)
endif()
set(command ${CMAKE_COMMAND} --build ${TEST_BINARY_DIR} --config Release --target ${install_target})
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
