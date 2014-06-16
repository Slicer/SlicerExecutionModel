
include(${TEST_SOURCE_DIR}/../CMake/GenerateCLPTestMacros.cmake)
include(${TEST_BINARY_DIR}/../CMake/GenerateCLPTestPrerequisites.cmake)

if(${generateclp_build_type} STREQUAL "")
  message(FATAL_ERROR "Make sure variable TEST_BUILD_TYPE is not empty. "
                      "TEST_BUILD_TYPE [${test_build_type}]")
endif()

# --------------------------------------------------------------------------
# Delete build directory if it exists
execute_process(
  COMMAND ${CMAKE_COMMAND} -E remove_directory ${TEST_BINARY_DIR}
  )

# --------------------------------------------------------------------------
# Create build directory
execute_process(
  COMMAND ${CMAKE_COMMAND} -E make_directory ${TEST_BINARY_DIR}
  )

# --------------------------------------------------------------------------
# Debug flags - Set to True to display the command as string
set(PRINT_COMMAND 0)

# --------------------------------------------------------------------------
# Configure
set(command ${CMAKE_COMMAND}
  -DCMAKE_BUILD_TYPE:STRING=${generateclp_build_type}
  -DGenerateCLP_DIR:PATH=${GenerateCLP_BINARY_DIR}
  -G ${generateclp_cmake_generator} ${TEST_SOURCE_DIR})
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
