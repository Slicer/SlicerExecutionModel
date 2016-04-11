cmake_minimum_required(VERSION 2.8.2)
project(PointExample1)

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
