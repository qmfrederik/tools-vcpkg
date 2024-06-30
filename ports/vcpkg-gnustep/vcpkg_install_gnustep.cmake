include_guard(GLOBAL)

set(Z_VCPKG_CMAKE_GET_VARS_CURRENT_LIST_DIR "${CMAKE_CURRENT_LIST_DIR}" CACHE INTERNAL "")

function(vcpkg_install_gnustep)
    if (VCPKG_TARGET_IS_LINUX)
        vcpkg_install_make(
            MAKEFILE GNUmakefile
            # Allow make to find gnustep-config, which is in bin/
            ADD_BIN_TO_PATH
        )
    else()
        message(FATAL_ERROR "${CMAKE_CURRENT_FUNCTION} is not implemented for your platform")
    endif()
endfunction()
