cmake_minimum_required(VERSION 3.16.3)
project(SEMMacroBuildCLIExample LANGUAGES C CXX)

if(NOT CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD 17)
endif()

find_package(SlicerExecutionModel REQUIRED)
include(${SlicerExecutionModel_USE_FILE})

set(_example_dir ${CMAKE_CURRENT_SOURCE_DIR}/../Slicer3Example)
SEMMacroBuildCLI(
  NAME Slicer3Example
  CLI_XML_FILE ${_example_dir}/Slicer3Example.xml
  DISABLE_DEFAULT_CXX_FILE
  ADDITIONAL_SRCS ${_example_dir}/Slicer3Example.cxx
  NO_INSTALL
  )

include(CTest)
add_test(NAME SEMMacroBuildCLIExample-Help COMMAND $<TARGET_FILE:Slicer3Example> --help)
