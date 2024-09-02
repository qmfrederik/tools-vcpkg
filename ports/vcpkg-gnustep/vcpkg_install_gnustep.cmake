include_guard(GLOBAL)

function(vcpkg_install_gnustep)
    if (VCPKG_TARGET_IS_LINUX OR VCPKG_TARGET_IS_WINDOWS)
        vcpkg_install_make(
            MAKEFILE GNUmakefile
            # Allow make to find gnustep-config, which is in bin/
            ADD_BIN_TO_PATH
        )
    else()
        message(FATAL_ERROR "${CMAKE_CURRENT_FUNCTION} is not implemented for your platform")
    endif()
endfunction()
