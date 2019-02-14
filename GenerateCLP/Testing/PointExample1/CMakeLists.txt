#-----------------------------------------------------------------------------
cmake_minimum_required(VERSION 3.9.5)
cmake_policy(VERSION 3.9.5...3.13.2)
#-----------------------------------------------------------------------------
# Configure & Build
#-----------------------------------------------------------------------------
include(${CMAKE_CURRENT_SOURCE_DIR}/../CMake/GenerateCLPTestMacros.cmake)
GenerateCLP_TEST_PROJECT(
  NAME PointExample1
)

