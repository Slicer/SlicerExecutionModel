#
# Depends on:
#  CMakeParseArguments.cmake from Cmake 2.8.4 or greater
#
if(CMAKE_PATCH_VERSION LESS 3)
  include(${SlicerExecutionModel_CMAKE_DIR}/Pre283CMakeParseArguments.cmake)
else()
  include(CMakeParseArguments)
endif()

macro(SEMMacroBuildCLI)
  set(options
    EXECUTABLE_ONLY
    NO_INSTALL VERBOSE
    )
  set(oneValueArgs
    NAME LOGO_HEADER
    FOLDER
    CLI_XML_FILE
    CLI_LIBRARY_WRAPPER_CXX
    CLI_SHARED_LIBRARY_WRAPPER_CXX # Deprecated
    RUNTIME_OUTPUT_DIRECTORY
    LIBRARY_OUTPUT_DIRECTORY
    ARCHIVE_OUTPUT_DIRECTORY
    INSTALL_RUNTIME_DESTINATION
    INSTALL_LIBRARY_DESTINATION
    INSTALL_ARCHIVE_DESTINATION
    )
  set(multiValueArgs
    ADDITIONAL_SRCS
    TARGET_LIBRARIES
    LINK_DIRECTORIES
    INCLUDE_DIRECTORIES
    )
  CMAKE_PARSE_ARGUMENTS(LOCAL_SEM
    "${options}"
    "${oneValueArgs}"
    "${multiValueArgs}"
    ${ARGN}
    )

  message(STATUS "Configuring SEM CLI module: ${LOCAL_SEM_NAME}")
  # --------------------------------------------------------------------------
  # Print information helpful for debugging checks
  # --------------------------------------------------------------------------
  if(LOCAL_SEM_VERBOSE)
    list(APPEND ALL_OPTIONS ${options} ${oneValueArgs} ${multiValueArgs})
    foreach(curr_opt ${ALL_OPTIONS})
      message(STATUS "${curr_opt} = ${LOCAL_SEM_${curr_opt}}")
    endforeach()
  endif()
  if(LOCAL_SEM_INSTALL_UNPARSED_ARGUMENTS)
    message(AUTHOR_WARNING "Unparsed arguments given [${LOCAL_SEM_INSTALL_UNPARSED_ARGUMENTS}]")
  endif()
  # --------------------------------------------------------------------------
  # Sanity checks
  # --------------------------------------------------------------------------
  if(NOT DEFINED LOCAL_SEM_NAME)
    message(FATAL_ERROR "NAME is mandatory: [${LOCAL_SEM_NAME}]")
  endif()

  if(DEFINED LOCAL_SEM_LOGO_HEADER AND NOT EXISTS ${LOCAL_SEM_LOGO_HEADER})
    message(AUTHOR_WARNING "Specified LOGO_HEADER [${LOCAL_SEM_LOGO_HEADER}] doesn't exist")
    set(LOCAL_SEM_LOGO_HEADER)
  endif()

  if(DEFINED LOCAL_SEM_CLI_SHARED_LIBRARY_WRAPPER_CXX)
    message(AUTHOR_WARNING "Parameter 'CLI_SHARED_LIBRARY_WRAPPER_CXX' is deprecated. Use 'CLI_LIBRARY_WRAPPER_CXX' instead.")
    set(LOCAL_SEM_CLI_LIBRARY_WRAPPER_CXX ${LOCAL_SEM_CLI_SHARED_LIBRARY_WRAPPER_CXX})
  endif()

  if(NOT DEFINED SlicerExecutionModel_CLI_LIBRARY_WRAPPER_CXX)
    set(LOCAL_SEM_CLI_LIBRARY_WRAPPER_CXX ${SlicerExecutionModel_DEFAULT_CLI_LIBRARY_WRAPPER_CXX})
  else()
    set(LOCAL_SEM_CLI_LIBRARY_WRAPPER_CXX ${SlicerExecutionModel_CLI_LIBRARY_WRAPPER_CXX})
  endif()

  foreach(v LOCAL_SEM_CLI_LIBRARY_WRAPPER_CXX)
    if(NOT EXISTS "${${v}}")
      message(FATAL_ERROR "Variable ${v} point to an non-existing file or directory !")
    endif()
  endforeach()

  if(DEFINED LOCAL_SEM_CLI_XML_FILE)
    set(cli_xml_file ${LOCAL_SEM_CLI_XML_FILE})
    if(NOT EXISTS ${cli_xml_file})
      message(FATAL_ERROR "Requested XML file [${cli_xml_file}] specified using CLI_XML_FILE doesn't exist !")
    endif()
  else()
    set(cli_xml_file ${CMAKE_CURRENT_SOURCE_DIR}/${LOCAL_SEM_NAME}.xml)
    if(NOT EXISTS ${cli_xml_file})
      set(cli_xml_file ${CMAKE_CURRENT_BINARY_DIR}/${LOCAL_SEM_NAME}.xml)
      if(NOT EXISTS ${cli_xml_file})
        message(FATAL_ERROR "Couldn't find XML file [${LOCAL_SEM_NAME}.xml] in either the current source directory [${CMAKE_CURRENT_SOURCE_DIR}] or the current build directory [${CMAKE_CURRENT_BINARY_DIR}] - Note that you could also specify a custom location using CLI_XML_FILE parameter !")
      endif()
    endif()
  endif()

  set(CLP ${LOCAL_SEM_NAME})

  find_package(SlicerExecutionModel REQUIRED GenerateCLP)
  include(${GenerateCLP_USE_FILE})

  set(${CLP}_SOURCE ${CLP}.cxx ${LOCAL_SEM_ADDITIONAL_SRCS})
  generateclp(${CLP}_SOURCE ${cli_xml_file} ${LOCAL_SEM_LOGO_HEADER})

  if(DEFINED LOCAL_SEM_LINK_DIRECTORIES)
    link_directories(${LOCAL_SEM_LINK_DIRECTORIES})
  endif()

  if(DEFINED LOCAL_SEM_INCLUDE_DIRECTORIES)
    include_directories(${LOCAL_SEM_INCLUDE_DIRECTORIES})
  endif()
  
  if(DEFINED SlicerExecutionModel_EXTRA_INCLUDE_DIRECTORIES)
    include_directories(${SlicerExecutionModel_EXTRA_INCLUDE_DIRECTORIES})
  endif()

  set(cli_targets)
  if(NOT LOCAL_SEM_EXECUTABLE_ONLY)
    set(cli_library_type SHARED)
    set(cli_executable_compile_flags "")
  else()
    set(cli_library_type STATIC)
    set(cli_executable_compile_flags "-DMODULE_STATIC")
  endif()

  add_library(${CLP}Lib ${cli_library_type} ${${CLP}_SOURCE})
  set_target_properties(${CLP}Lib PROPERTIES COMPILE_FLAGS "-Dmain=ModuleEntryPoint")
  if(DEFINED LOCAL_SEM_TARGET_LIBRARIES)
    target_link_libraries(${CLP}Lib ${LOCAL_SEM_TARGET_LIBRARIES})
  endif()
  if(NOT "${DEFAULT_SEM_TARGET_LIBRARIES}" STREQUAL "")
    target_link_libraries(${CLP}Lib ${DEFAULT_SEM_TARGET_LIBRARIES})
  endif()

  # Specify which link flags should be associated with CLI library
  set(_cli_library_link_flags )
  if(NOT DEFINED SlicerExecutionModel_CLI_LIBRARY_LINK_FLAGS)
    set(_cli_library_link_flags ${SlicerExecutionModel_DEFAULT_CLI_LIBRARY_LINK_FLAGS})
  else()
    set(_cli_library_link_flags ${SlicerExecutionModel_CLI_LIBRARY_LINK_FLAGS})
  endif()
  if(NOT "${_cli_library_link_flags}" STREQUAL "")
    set_target_properties(${CLP}Lib PROPERTIES LINK_FLAGS ${_cli_library_link_flags})
  endif()

  add_executable(${CLP} ${LOCAL_SEM_CLI_LIBRARY_WRAPPER_CXX})
  set_target_properties(${CLP} PROPERTIES COMPILE_FLAGS "${cli_executable_compile_flags}")
  set(cli_executable_libraries ${CLP}Lib)
  if(DEFINED SlicerExecutionModel_EXTRA_EXECUTABLE_TARGET_LIBRARIES)
    list(APPEND cli_executable_libraries ${SlicerExecutionModel_EXTRA_EXECUTABLE_TARGET_LIBRARIES})
  endif()
  if(NOT "${DEFAULT_SEM_TARGET_LIBRARIES}" STREQUAL "")
    list(APPEND cli_executable_libraries ${DEFAULT_SEM_TARGET_LIBRARIES})
  endif()
  target_link_libraries(${CLP} ${cli_executable_libraries})

  set(cli_targets ${CLP} ${CLP}Lib)

  # Specify which link flags should be associated with CLI executable
  set(_cli_executable_link_flags )
  if(NOT DEFINED SlicerExecutionModel_CLI_EXECUTABLE_LINK_FLAGS)
    set(_cli_executable_link_flags ${SlicerExecutionModel_DEFAULT_CLI_EXECUTABLE_LINK_FLAGS})
  else()
    set(_cli_executable_link_flags ${SlicerExecutionModel_CLI_EXECUTABLE_LINK_FLAGS})
  endif()
  if(NOT "${_cli_executable_link_flags}" STREQUAL "")
    set_target_properties(${CLP} PROPERTIES LINK_FLAGS ${_cli_executable_link_flags})
  endif()

  # Set labels associated with the target.
  set_target_properties(${cli_targets} PROPERTIES LABELS ${CLP})
  
  # Define default Output directories if it applies
  foreach(type RUNTIME LIBRARY ARCHIVE)
    if(NOT DEFINED LOCAL_SEM_${type}_OUTPUT_DIRECTORY)
      if(NOT DEFINED SlicerExecutionModel_CLI_${type}_OUTPUT_DIRECTORY)
        set(LOCAL_SEM_${type}_OUTPUT_DIRECTORY ${SlicerExecutionModel_DEFAULT_CLI_${type}_OUTPUT_DIRECTORY})
      else()
        set(LOCAL_SEM_${type}_OUTPUT_DIRECTORY ${SlicerExecutionModel_CLI_${type}_OUTPUT_DIRECTORY})
      endif()
      if(LOCAL_SEM_VERBOSE)
        message(STATUS "Defaulting ${type}_OUTPUT_DIRECTORY to ${LOCAL_SEM_${type}_OUTPUT_DIRECTORY}")
      endif()
    endif()
  endforeach()

  set_target_properties(${cli_targets} PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${LOCAL_SEM_RUNTIME_OUTPUT_DIRECTORY}"
    LIBRARY_OUTPUT_DIRECTORY "${LOCAL_SEM_LIBRARY_OUTPUT_DIRECTORY}"
    ARCHIVE_OUTPUT_DIRECTORY "${LOCAL_SEM_ARCHIVE_OUTPUT_DIRECTORY}"
    )

  if(NOT LOCAL_SEM_NO_INSTALL)
    # Define default install destination if it applies
    foreach(type RUNTIME LIBRARY ARCHIVE)
      if(NOT DEFINED LOCAL_SEM_INSTALL_${type}_DESTINATION)
        if(NOT DEFINED SlicerExecutionModel_CLI_INSTALL_${type}_DESTINATION)
          set(LOCAL_SEM_INSTALL_${type}_DESTINATION ${SlicerExecutionModel_DEFAULT_CLI_INSTALL_${type}_DESTINATION})
        else()
          set(LOCAL_SEM_INSTALL_${type}_DESTINATION ${SlicerExecutionModel_CLI_INSTALL_${type}_DESTINATION})
        endif()
        if(LOCAL_SEM_VERBOSE)
          message(STATUS "Defaulting INSTALL_${type}_DESTINATION to ${LOCAL_SEM_INSTALL_${type}_DESTINATION}")
        endif()
      endif()
    endforeach()

    # Install each target in the production area (where it would appear in an installation)
    # and install each target in the developer area (for running from a build)
    install(TARGETS ${cli_targets}
      RUNTIME DESTINATION ${LOCAL_SEM_INSTALL_RUNTIME_DESTINATION} COMPONENT RuntimeLibraries
      LIBRARY DESTINATION ${LOCAL_SEM_INSTALL_LIBRARY_DESTINATION} COMPONENT RuntimeLibraries
      ARCHIVE DESTINATION ${LOCAL_SEM_INSTALL_ARCHIVE_DESTINATION} COMPONENT Development
      )
  endif()

  # Folder
  if(NOT DEFINED LOCAL_SEM_FOLDER)
    set(LOCAL_SEM_FOLDER "${SlicerExecutionModel_DEFAULT_CLI_TARGETS_FOLDER_PREFIX}${LOCAL_SEM_NAME}")
  endif()
  foreach(target ${cli_targets})
    set_target_properties(${target} PROPERTIES FOLDER ${LOCAL_SEM_FOLDER})
  endforeach()
  set(${MODULE_NAME}_TARGETS_FOLDER ${LOCAL_SEM_FOLDER})

endmacro()

