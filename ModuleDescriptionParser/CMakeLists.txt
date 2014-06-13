project(ModuleDescriptionParser)

#-----------------------------------------------------------------------------
cmake_minimum_required(VERSION 2.8.6)
#-----------------------------------------------------------------------------

#-----------------------------------------------------------------------------
# See http://cmake.org/cmake/help/cmake-2-8-docs.html#section_Policies for details
#-----------------------------------------------------------------------------
if(POLICY CMP0016)
  cmake_policy(SET CMP0016 NEW)
endif()
if(POLICY CMP0017)
  cmake_policy(SET CMP0017 OLD)
endif()

# --------------------------------------------------------------------------
# Prerequisites
# --------------------------------------------------------------------------
find_package(ITK REQUIRED) ## ITK is required for expat.h
include(${ITK_USE_FILE})

if(ModuleDescriptionParser_USE_PYTHON)
  find_package(PythonLibs)
endif()

# --------------------------------------------------------------------------
# Option(s)
# --------------------------------------------------------------------------
if(NOT DEFINED BUILD_SHARED_LIBS)
  option(BUILD_SHARED_LIBS "Build with shared libraries." ON)
endif()

if(NOT DEFINED ModuleDescriptionParser_USE_SERIALIZER)
  option(ModuleDescriptionParser_USE_SERIALIZER "Serialization and deserialization support is added for ModuleDescriptionParser objects." OFF)
  mark_as_advanced(ModuleDescriptionParser_USE_SERIALIZER)
endif()
if(ModuleDescriptionParser_USE_SERIALIZER)
  find_package(ParameterSerializer REQUIRED)
  include_directories(${ParameterSerializer_INCLUDE_DIRS})
endif()

#-----------------------------------------------------------------------------
# Testing
#-----------------------------------------------------------------------------
include(CTest)

#-----------------------------------------------------------------------------
# Output directories.
#-----------------------------------------------------------------------------
foreach(type LIBRARY RUNTIME ARCHIVE)
  # Make sure the directory exists
  if(DEFINED ModuleDescriptionParser_CMAKE_${type}_OUTPUT_DIRECTORY
     AND NOT EXISTS ${ModuleDescriptionParser_CMAKE_${type}_OUTPUT_DIRECTORY})
    message(FATAL_ERROR "ModuleDescriptionParser_CMAKE_${type}_OUTPUT_DIRECTORY is set to a non-existing directory [${ModuleDescriptionParser_CMAKE_${type}_OUTPUT_DIRECTORY}]")
  endif()

  if(NOT DEFINED ModuleDescriptionParser_CMAKE_${type}_OUTPUT_DIRECTORY)
    set(ModuleDescriptionParser_CMAKE_${type}_OUTPUT_DIRECTORY ${ModuleDescriptionParser_BINARY_DIR}/bin)
  endif()
  set(CMAKE_${type}_OUTPUT_DIRECTORY ${ModuleDescriptionParser_CMAKE_${type}_OUTPUT_DIRECTORY} CACHE INTERNAL "Single output directory for building all libraries.")
endforeach()

# --------------------------------------------------------------------------
# Include dirs
# --------------------------------------------------------------------------
set(include_dirs
  ${CMAKE_CURRENT_BINARY_DIR}
  ${CMAKE_CURRENT_SOURCE_DIR}
  )

if(ModuleDescriptionParser_USE_PYTHON)
  set(include_dirs ${include_dirs} ${PYTHON_INCLUDE_PATH})
  if(WIN32)
    set(include_dirs ${include_dirs} ${PYTHON_INCLUDE_PATH}/../PC)
  endif()
endif()

include_directories(${include_dirs})

# --------------------------------------------------------------------------
# Configure headers
# --------------------------------------------------------------------------
set(configure_header_file ModuleDescriptionParserConfigure.h)
configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/${configure_header_file}.in
  ${CMAKE_CURRENT_BINARY_DIR}/${configure_header_file}
  )

# --------------------------------------------------------------------------
# Install headers
# --------------------------------------------------------------------------
if(NOT DEFINED ${PROJECT_NAME}_INSTALL_NO_DEVELOPMENT)
  set(${PROJECT_NAME}_INSTALL_NO_DEVELOPMENT ON)
endif()
if(NOT ${PROJECT_NAME}_INSTALL_NO_DEVELOPMENT)
  install(FILES
    BatchMakeUtilities.h
    BinaryFileDescriptor.h
    itkSEMModuleDescriptionSerializer.h
    itkSEMModuleParameterGroupSerializer.h
    itkSEMModuleParameterSerializer.h
    JsonSerializationUtilities.h
    ModuleDescription.h
    ModuleDescriptionParser.h
    ModuleDescriptionUtilities.h
    ModuleFactory.h
    ModuleLogo.h
    ModuleParameterGroup.h
    ModuleParameter.h
    ModuleProcessInformation.h
    ${CMAKE_CURRENT_BINARY_DIR}/ModuleDescriptionParserExport.h
    ${CMAKE_CURRENT_BINARY_DIR}/${configure_header_file}
    DESTINATION include/${PROJECT_NAME}
    COMPONENT Development
    )
endif()

# --------------------------------------------------------------------------
# Sources
# --------------------------------------------------------------------------
set(ModuleDescriptionParser_SRCS
  ModuleParameter.cxx
  ModuleParameterGroup.cxx
  ModuleDescriptionUtilities.cxx
  ModuleDescription.cxx
  ModuleDescriptionParser.cxx
  ModuleProcessInformation.cxx
  ModuleLogo.cxx
  ModuleFactory.cxx
  BatchMakeUtilities.cxx
  )
if(ModuleDescriptionParser_USE_SERIALIZER)
  list(APPEND ModuleDescriptionParser_SRCS
    itkSEMModuleDescriptionSerializer.cxx
    itkSEMModuleParameterSerializer.cxx
    itkSEMModuleParameterGroupSerializer.cxx
    )
endif()

# --------------------------------------------------------------------------
# Enable Binary File Descriptor support if available
# --------------------------------------------------------------------------
if(USE_BFD)
  if(NOT WIN32)
    include(CheckIncludeFile)
    check_include_file(bfd.h HAVE_BFD_HEADER)

    if(HAVE_BFD_HEADER)
      # make sure we can build with libbfd
      message(STATUS "Testing libbfd")
      try_compile(HAVE_BFD
        ${CMAKE_CURRENT_BINARY_DIR}/CMake
        ${CMAKE_CURRENT_SOURCE_DIR}/CMake
        TestBFD
        CMAKE_FLAGS
        -DBUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        OUTPUT_VARIABLE OUTPUT)
      message(${OUTPUT})

      if(HAVE_BFD)
        message(STATUS "Testing libbfd - ok. ModuleFactory will look for global symbols in plugin executables.")
      else()
        message(STATUS "Testing libbfd - error.  ModuleFactory will not look for global symbols in plugin executables.")
      endif()

    endif()

    if(HAVE_BFD)
      set(ModuleDescriptionParser_SRCS
        ${ModuleDescriptionParser_SRCS}
        BinaryFileDescriptor.cxx)
    endif()
  endif()
endif()

# --------------------------------------------------------------------------
# Build library
# --------------------------------------------------------------------------
set(lib_name ModuleDescriptionParser)
include(GenerateExportHeader)
add_compiler_export_flags()
add_library(${lib_name} ${ModuleDescriptionParser_SRCS})
generate_export_header(${lib_name}
  BASE_NAME ${lib_name}
  EXPORT_MACRO_NAME ${lib_name}_EXPORT
  EXPORT_FILE_NAME ${lib_name}Export.h
  STATIC_DEFINE ${lib_name}_STATIC
  )

## Always build an explicitly static library for linking against GenerateCLP so that
## GenerateCLP can be run from CMake without having to set DYLD_LIBRARY_PATH or LD_LIBRARY_PATH
## to the future location of of libModuleDescriptionParser.so
## add_library(${lib_name}-static STATIC
  ## ${ModuleDescriptionParser_SRCS}
  ## )

set(libs
  ITKEXPAT
  itksys
  )

#
# Append extra platform dependent libraries required for linking
#
if(ModuleDescriptionParser_USE_PYTHON)
  list(APPEND libs ${PYTHON_LIBRARIES})
endif()

if(NOT WIN32 AND NOT APPLE AND NOT UNIX)
  list(APPEND libs util pthread)
endif()

if(UNIX)
  list(APPEND libs pthread)
endif()

if(NOT WIN32 AND HAVE_BFD)
  list(APPEND libs bfd iberty)
endif()

if(ModuleDescriptionParser_USE_SERIALIZER)
  list(APPEND libs ${ParameterSerializer_LIBRARIES})
endif()

target_link_libraries(${lib_name} ${libs})
## target_link_libraries(${lib_name}-static ${link_libs})

#
# Apply user-defined properties to the library target.
#
if(ModuleDescriptionParser_LIBRARY_PROPERTIES)
  set_target_properties(${lib_name} PROPERTIES ${ModuleDescriptionParser_LIBRARY_PROPERTIES})
endif()

# --------------------------------------------------------------------------
# Export target
# --------------------------------------------------------------------------
set(${PROJECT_NAME}_TARGETS ${lib_name} CACHE INTERNAL "${PROJECT_NAME} targets" FORCE)
export(TARGETS ${lib_name} FILE ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Targets.cmake)

# --------------------------------------------------------------------------
# Install library
# --------------------------------------------------------------------------
if(NOT DEFINED ${PROJECT_NAME}_INSTALL_BIN_DIR)
  set(${PROJECT_NAME}_INSTALL_BIN_DIR bin)
endif()

if(NOT DEFINED ${PROJECT_NAME}_INSTALL_LIB_DIR)
  set(${PROJECT_NAME}_INSTALL_LIB_DIR lib/${PROJECT_NAME})
endif()

install(TARGETS ${lib_name}
  RUNTIME DESTINATION ${${PROJECT_NAME}_INSTALL_BIN_DIR} COMPONENT RuntimeLibraries
  LIBRARY DESTINATION ${${PROJECT_NAME}_INSTALL_LIB_DIR} COMPONENT RuntimeLibraries
  ARCHIVE DESTINATION ${${PROJECT_NAME}_INSTALL_LIB_DIR} COMPONENT Development
  )

# --------------------------------------------------------------------------
# Testing
# --------------------------------------------------------------------------
if(BUILD_TESTING)
  add_subdirectory(Testing)
endif()

# --------------------------------------------------------------------------
# Install support files
# --------------------------------------------------------------------------
if(NOT ${PROJECT_NAME}_INSTALL_NO_DEVELOPMENT)
  install(FILES
    ${CMAKE_CURRENT_BINARY_DIR}/UseModuleDescriptionParser.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/install/ModuleDescriptionParserConfig.cmake
    DESTINATION lib/${lib_name} COMPONENT Development)
endif()

# --------------------------------------------------------------------------
# Set INCLUDE_DIRS variable
# --------------------------------------------------------------------------
set(${PROJECT_NAME}_INCLUDE_DIRS ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR}
  CACHE INTERNAL "${PROJECT_NAME} include dirs" FORCE)

# --------------------------------------------------------------------------
# Configure support files
# --------------------------------------------------------------------------
include(GenerateModuleDescriptionParserConfig.cmake)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/UseModuleDescriptionParser.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/UseModuleDescriptionParser.cmake COPYONLY)

