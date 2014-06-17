
# --------------------------------------------------------------------------
# Helper macro
function(print_command_as_string command)
  if(PRINT_COMMAND)
    set(command_as_string)
    foreach(elem ${command})
      set(command_as_string "${command_as_string} ${elem}")
    endforeach()
    message(STATUS "COMMAND:${command_as_string}")
  endif()
endfunction()

