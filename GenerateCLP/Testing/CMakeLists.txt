find_package(GenerateCLP NO_MODULE REQUIRED)
include(${GenerateCLP_USE_FILE})

set( TEMP ${PROJECT_BINARY_DIR}/Testing/Temporary )
file( MAKE_DIRECTORY ${TEMP} )

if( GenerateCLP_USE_JSONCPP )
  include_directories( ${JsonCpp_INCLUDE_DIRS} )
endif()

set( _additional_link_libraries )
if( GenerateCLP_USE_JSONCPP )
  list(APPEND _additional_link_libraries ${JsonCpp_LIBRARIES})
endif()
if( GenerateCLP_USE_SERIALIZER )
  list(APPEND _additional_link_libraries ${ParameterSerializer_LIBRARIES})
endif()

set( CLPEXAMPLE1_SOURCE CLPExample1.cxx )
GENERATECLP(CLPEXAMPLE1_SOURCE CLPExample1.xml)
add_executable( CLPExample1 ${CLPEXAMPLE1_SOURCE})
target_link_libraries( CLPExample1 ITKEXPAT ${_additional_link_libraries})

set( POINTEXAMPLE1_SOURCE PointExample1.cxx )
GENERATECLP(POINTEXAMPLE1_SOURCE PointExample1.xml)
add_executable( PointExample1 ${POINTEXAMPLE1_SOURCE})
target_link_libraries( PointExample1 ITKEXPAT ${_additional_link_libraries})

set( SLICEREXAMPLE_SOURCE Slicer3Example.cxx )
GENERATECLP(SLICEREXAMPLE_SOURCE Slicer3Example.xml)
add_executable( SlicerExample ${SLICEREXAMPLE_SOURCE})
target_link_libraries(SlicerExample ${_additional_link_libraries})

add_test(NAME SlicerCLPExample1 COMMAND $<TARGET_FILE:SlicerExample> --help)
add_test(NAME SlicerCLPExample2 COMMAND $<TARGET_FILE:SlicerExample> --echo --load_freesurfer_volume FSV --stereo)
add_test(NAME SlicerCLPExample3 COMMAND $<TARGET_FILE:SlicerExample>)

if( GenerateCLP_USE_SERIALIZER )
  add_test( NAME GenerateCLPSerializer-CLPExample1-Test1
    COMMAND $<TARGET_FILE:CLPExample1>
    --spatialsamples 3324
    --selection 4
    --interpolation sinc
    --learningrate 0.002,0.001,0.0007,0.0002
    --translationscale 20
    --serialize ./GenerateCLPSerializer-CLPExample1-Test1.json
    2
    Head.mha
    ProgrammingHead.mha
    ShrunkHead.mha
    WORKING_DIRECTORY ${TEMP}
    )

  add_test( NAME GenerateCLPSerializer-CLPExample1-Test2
    COMMAND $<TARGET_FILE:CLPExample1>
    --deserialize ./GenerateCLPSerializer-CLPExample1-Test1.json
    --serialize ./GenerateCLPSerializer-CLPExample1-Test2.json
    2
    Head.mha
    ProgrammingHead.mha
    ShrunkHead.mha
    WORKING_DIRECTORY ${TEMP}
    )
  set_tests_properties( GenerateCLPSerializer-CLPExample1-Test2
    PROPERTIES DEPENDS GenerateCLPSerializer-CLPExample1-Test1 )

  add_test( NAME GenerateCLPSerializer-CLPExample1-Test3
    COMMAND $<TARGET_FILE:CLPExample1>
    --deserialize ./GenerateCLPSerializer-CLPExample1-Test1.json
    --serialize ./GenerateCLPSerializer-CLPExample1-Test3.json
    --spatialsamples 2112
    --learningrate 0.001,0.001,0.0005,0.0003
    2
    Head.mha
    ProgrammingHead.mha
    ShrunkHead.mha
    WORKING_DIRECTORY ${TEMP}
    )
  set_tests_properties( GenerateCLPSerializer-CLPExample1-Test3
    PROPERTIES DEPENDS GenerateCLPSerializer-CLPExample1-Test1 )
endif()
