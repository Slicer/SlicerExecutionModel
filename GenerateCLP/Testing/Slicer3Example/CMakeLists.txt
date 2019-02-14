#-----------------------------------------------------------------------------
cmake_minimum_required(VERSION 3.9.5)
cmake_policy(VERSION 3.9.5...3.13.2)
include(${CMAKE_CURRENT_SOURCE_DIR}/../CMake/GenerateCLPTestMacros.cmake)

#-----------------------------------------------------------------------------
# Configure & Build
#-----------------------------------------------------------------------------
GenerateCLP_TEST_PROJECT(
  NAME Slicer3Example
)

#-----------------------------------------------------------------------------
# Test
#-----------------------------------------------------------------------------
add_test(NAME SlicerCLPExample1 COMMAND $<TARGET_FILE:${PROJECT_NAME}> --help)
add_test(NAME SlicerCLPExample2 COMMAND $<TARGET_FILE:${PROJECT_NAME}> --echo --load_freesurfer_volume FSV --stereo)
add_test(NAME SlicerCLPExample3 COMMAND $<TARGET_FILE:${PROJECT_NAME}>)
