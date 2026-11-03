foreach(varname SEM_BINARY_DIR TEST_INSTALL_DIR TEST_CONFIGURATION)
  if(NOT DEFINED ${varname})
    message(FATAL_ERROR "Variable ${varname} is not DEFINED")
  endif()
endforeach()

file(REMOVE_RECURSE ${TEST_INSTALL_DIR})

set(command ${CMAKE_COMMAND} --install ${SEM_BINARY_DIR} --prefix ${TEST_INSTALL_DIR})
if(TEST_CONFIGURATION)
  list(APPEND command --config ${TEST_CONFIGURATION})
endif()
execute_process(
  COMMAND ${command}
  OUTPUT_VARIABLE ov
  ERROR_VARIABLE ov
  RESULT_VARIABLE rv
  )
if(rv)
  message(FATAL_ERROR "Failed to install SlicerExecutionModel:\n${ov}")
endif()
