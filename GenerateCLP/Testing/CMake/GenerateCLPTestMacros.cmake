
# --------------------------------------------------------------------------
# Helper macro
function(print_command_as_string command)
  if(PRINT_COMMAND)
    set(command_as_string)
    foreach(elem ${command})
      set(command_as_string "${command_as_string} ${elem}")
    endforeach()
    message(STATUS "COMMAND:${command_as_string}")
  endif()
endfunction()

# --------------------------------------------------------------------------
# Macro used to generate CLIs to test GenerateCLP with
macro(GenerateCLP_TEST_PROJECT)
  include(CMakeParseArguments)

  set(options)
  set(oneValueArgs NAME)
  set(multiValueArgs)
  cmake_parse_arguments(TEST_CLI "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )

  project(${TEST_CLI_NAME})

  find_package(GenerateCLP NO_MODULE REQUIRED)
  include(${GenerateCLP_USE_FILE})

  #-----------------------------------------------------------------------------
  if(GenerateCLP_USE_JSONCPP)
    set(CMAKE_MODULE_PATH ${JsonCpp_CMAKE_MODULE_PATH} ${CMAKE_MODULE_PATH}) # Needed to locate FindJsonCpp.cmake
    find_package(JsonCpp REQUIRED)
    include_directories(${JsonCpp_INCLUDE_DIRS})
  endif()

  set(_additional_link_libraries)
  if(GenerateCLP_USE_JSONCPP)
    list(APPEND _additional_link_libraries ${JsonCpp_LIBRARIES})
  endif()
  if(GenerateCLP_USE_SERIALIZER)
    list(APPEND _additional_link_libraries ${ParameterSerializer_LIBRARIES})
  endif()

  #-----------------------------------------------------------------------------
  # Build
  #-----------------------------------------------------------------------------

  set(${PROJECT_NAME}_SOURCE ${PROJECT_NAME}.cxx)
  GENERATECLP(${PROJECT_NAME}_SOURCE ${PROJECT_NAME}.xml)
  add_executable(${PROJECT_NAME} ${${PROJECT_NAME}_SOURCE})
  if(_additional_link_libraries)
    target_link_libraries(${PROJECT_NAME} ${_additional_link_libraries})
  endif()
  #-----------------------------------------------------------------------------
  # Test
  #-----------------------------------------------------------------------------
  include(CTest)

  set(TEMP ${PROJECT_BINARY_DIR}/Testing/Temporary)
  file(MAKE_DIRECTORY ${TEMP})
endmacro()
