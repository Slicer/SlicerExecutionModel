cmake_minimum_required(VERSION 2.8.2)
project(Slicer3Example)

find_package(GenerateCLP NO_MODULE REQUIRED)
include(${GenerateCLP_USE_FILE})

#-----------------------------------------------------------------------------
# Build
#-----------------------------------------------------------------------------

set(${PROJECT_NAME}_SOURCE ${PROJECT_NAME}.cxx)
GENERATECLP(${PROJECT_NAME}_SOURCE ${PROJECT_NAME}.xml)
add_executable(${PROJECT_NAME} ${${PROJECT_NAME}_SOURCE})
target_link_libraries(${PROJECT_NAME} ITKEXPAT)
if(GenerateCLP_USE_SERIALIZER)
  target_link_libraries(${PROJECT_NAME} ${ParameterSerializer_LIBRARIES})
endif()

#-----------------------------------------------------------------------------
# Test
#-----------------------------------------------------------------------------
include(CTest)
add_test(NAME SlicerCLPExample1 COMMAND $<TARGET_FILE:${PROJECT_NAME}> --help)
add_test(NAME SlicerCLPExample2 COMMAND $<TARGET_FILE:${PROJECT_NAME}> --echo --load_freesurfer_volume FSV --stereo)
add_test(NAME SlicerCLPExample3 COMMAND $<TARGET_FILE:${PROJECT_NAME}>)
