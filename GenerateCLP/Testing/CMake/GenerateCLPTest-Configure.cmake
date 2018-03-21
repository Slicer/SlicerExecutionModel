
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
if(TEST_TREETYPE STREQUAL "BuildTree")
  set(GenerateCLP_DIR ${GenerateCLP_BINARY_DIR})
endif()

# --------------------------------------------------------------------------
# Configure
set(command ${CMAKE_COMMAND}
  -DCMAKE_BUILD_TYPE:STRING=${generateclp_build_type}
  -DGenerateCLP_DIR:PATH=${GenerateCLP_DIR}
  -DGenerateCLP_USE_JSONCPP:BOOL=${GenerateCLP_USE_JSONCPP}
  -DJsonCpp_CMAKE_MODULE_PATH:PATH=${JsonCpp_CMAKE_MODULE_PATH}
  -G ${generateclp_cmake_generator} ${TEST_SOURCE_DIR})
if(GenerateCLP_USE_JSONCPP)
  list(APPEND command
    -DJsonCpp_DIR:PATH=${JsonCpp_DIR}
    )
endif()
execute_process(
  COMMAND ${command}
  WORKING_DIRECTORY ${TEST_BINARY_DIR}
  OUTPUT_VARIABLE ov
  RESULT_VARIABLE rv
  )

print_command_as_string("${command}" "${TEST_BINARY_DIR}")

if(rv)
  message(FATAL_ERROR "Failed to configure Test:\n${ov}")
endif()
