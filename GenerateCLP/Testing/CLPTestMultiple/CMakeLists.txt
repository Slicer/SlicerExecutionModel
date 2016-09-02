cmake_minimum_required(VERSION 2.8.6)
project(CLPTestMultiple)

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

if(GenerateCLP_USE_SERIALIZER)
  list(APPEND FLAGS_TO_TEST
  --int
  --file
  --dir
  --image
  --geo
  --point
  --pointFile
  --roi
  )
  foreach(flag ${FLAGS_TO_TEST})
    add_test(NAME GenerateCLPSerializer-${PROJECT_NAME}${flag}-Test1
      COMMAND $<TARGET_FILE:${PROJECT_NAME}>
      ${flag} 1
      ${flag} 2,3,4
      --interruptionFlag
      ${flag} 5,6
      --serialize ./GenerateCLPSerializer-${PROJECT_NAME}${flag}-Test1.json
      WORKING_DIRECTORY ${TEMP}
      )

    # Test deserialization with no other args
    add_test(NAME GenerateCLPSerializer-${PROJECT_NAME}${flag}-Test2
      COMMAND $<TARGET_FILE:${PROJECT_NAME}>
      --deserialize ./GenerateCLPSerializer-${PROJECT_NAME}${flag}-Test1.json
      WORKING_DIRECTORY ${TEMP}
      )
    set_tests_properties( GenerateCLPSerializer-${PROJECT_NAME}${flag}-Test2
      PROPERTIES DEPENDS GenerateCLPSerializer-${PROJECT_NAME}${flag}-Test1)

    # Test deserialize with new arguments
    add_test(NAME GenerateCLPSerializer-${PROJECT_NAME}${flag}-Test3
      COMMAND $<TARGET_FILE:${PROJECT_NAME}>
      --testCommandLineOverWrite
      --deserialize ./GenerateCLPSerializer-${PROJECT_NAME}${flag}-Test1.json
      ${flag} -1,-2
      --interruptionFlag
      ${flag} -3
      ${flag} -4,-5,-6
      WORKING_DIRECTORY ${TEMP}
      )
    set_tests_properties( GenerateCLPSerializer-${PROJECT_NAME}${flag}-Test3
      PROPERTIES DEPENDS GenerateCLPSerializer-${PROJECT_NAME}${flag}-Test1)
  endforeach()

endif()
