cmake_minimum_required(VERSION 2.8.6)

#-----------------------------------------------------------------------------
# Configure & Build
#-----------------------------------------------------------------------------
include(${CMAKE_CURRENT_SOURCE_DIR}/../CMake/GenerateCLPTestMacros.cmake)
GenerateCLP_TEST_PROJECT(
  NAME PointExample1
)

