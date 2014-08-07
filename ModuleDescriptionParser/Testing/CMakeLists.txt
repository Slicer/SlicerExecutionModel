# --------------------------------------------------------------------------
# Build tests
# --------------------------------------------------------------------------
set(KIT ${PROJECT_NAME})
create_test_sourcelist(Tests ${KIT}CxxTests.cxx
  ModuleDescriptionTest.cxx
  )

add_executable(${KIT}CxxTests ${Tests})
target_link_libraries(${KIT}CxxTests ${KIT})

# --------------------------------------------------------------------------
# Build Parser1Test executable
# --------------------------------------------------------------------------
set(PARSER1TEST_SOURCE Parser1Test.cxx )
add_executable(Parser1Test ${PARSER1TEST_SOURCE})
target_link_libraries(Parser1Test ModuleDescriptionParser )

# --------------------------------------------------------------------------
# Build ModuleFactoryTest executable
# --------------------------------------------------------------------------
#set(ModuleFactoryTest_SOURCE ModuleFactoryTest.cxx)
#add_executable(ModuleFactoryTest ${ModuleFactoryTest_SOURCE})
#target_link_libraries(ModuleFactoryTest ModuleDescriptionParser )

#include_directories(
#  ${ModuleDescriptionParser_SOURCE_DIR}
#  )

# --------------------------------------------------------------------------
# Add tests
# --------------------------------------------------------------------------
set(TEST_DATA ${CMAKE_CURRENT_SOURCE_DIR}/TestData)
add_test(
  NAME Parser1Test1
  COMMAND ${Slicer_LAUNCH_COMMAND} $<TARGET_FILE:Parser1Test> ${TEST_DATA}/ParserTest1.xml
  )

add_test(
  NAME Parser1Test2
  COMMAND ${Slicer_LAUNCH_COMMAND} $<TARGET_FILE:Parser1Test> ${TEST_DATA}/ParserTest2.xml)

add_test(
  NAME ModuleDescriptionTest
  COMMAND ${Slicer_LAUNCH_COMMAND} $<TARGET_FILE:${KIT}CxxTests> ModuleDescriptionTest ${TEST_DATA}
  )

#add_test(
#  NAME ModuleFactoryTest
#  COMMAND ${Slicer_LAUNCH_COMMAND} $<TARGET_FILE:ModuleFactoryTest>
#    ${Slicer_BINARY_DIR}/${Slicer_INSTALL_PLUGINS_BIN_DIR}/
#  )

