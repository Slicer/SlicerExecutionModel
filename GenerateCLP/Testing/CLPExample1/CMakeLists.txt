cmake_minimum_required(VERSION 2.8.2)
project(CLPExample1)

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
target_link_libraries(${PROJECT_NAME} ITKEXPAT ${_additional_link_libraries})

#-----------------------------------------------------------------------------
# Test
#-----------------------------------------------------------------------------
include(CTest)

set(TEMP ${PROJECT_BINARY_DIR}/Testing/Temporary)
file(MAKE_DIRECTORY ${TEMP})

if(GenerateCLP_USE_SERIALIZER)
  add_test(NAME GenerateCLPSerializer-${PROJECT_NAME}-Test1
    COMMAND $<TARGET_FILE:${PROJECT_NAME}>
    --spatialsamples 3324
    --selection 4
    --interpolation sinc
    --learningrate 0.002,0.001,0.0007,0.0002
    --translationscale 20
    --serialize ./GenerateCLPSerializer-${PROJECT_NAME}-Test1.json
    2
    Head.mha
    ProgrammingHead.mha
    ShrunkHead.mha
    WORKING_DIRECTORY ${TEMP}
    )

  add_test(NAME GenerateCLPSerializer-${PROJECT_NAME}-Test2
    COMMAND $<TARGET_FILE:${PROJECT_NAME}>
    --deserialize ./GenerateCLPSerializer-${PROJECT_NAME}-Test1.json
    --serialize ./GenerateCLPSerializer-${PROJECT_NAME}-Test2.json
    2
    Head.mha
    ProgrammingHead.mha
    ShrunkHead.mha
    WORKING_DIRECTORY ${TEMP}
    )
  set_tests_properties( GenerateCLPSerializer-${PROJECT_NAME}-Test2
    PROPERTIES DEPENDS GenerateCLPSerializer-${PROJECT_NAME}-Test1)

  add_test(NAME GenerateCLPSerializer-${PROJECT_NAME}-Test3
    COMMAND $<TARGET_FILE:${PROJECT_NAME}>
    --deserialize ./GenerateCLPSerializer-${PROJECT_NAME}-Test1.json
    --serialize ./GenerateCLPSerializer-${PROJECT_NAME}-Test3.json
    --spatialsamples 2112
    --learningrate 0.001,0.001,0.0005,0.0003
    2
    Head.mha
    ProgrammingHead.mha
    ShrunkHead.mha
    WORKING_DIRECTORY ${TEMP}
    )
  set_tests_properties( GenerateCLPSerializer-${PROJECT_NAME}-Test3
    PROPERTIES DEPENDS GenerateCLPSerializer-${PROJECT_NAME}-Test1)
endif()
