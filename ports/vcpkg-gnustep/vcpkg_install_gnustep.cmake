include_guard(GLOBAL)

function(vcpkg_install_gnustep)
    cmake_parse_arguments(PARSE_ARGV 0 "arg"
        ""
        ""
        "OPTIONS"
    )

    list(JOIN ${arg_OPTIONS} " " options_string)

    if (VCPKG_TARGET_IS_LINUX OR VCPKG_TARGET_IS_WINDOWS)
        vcpkg_build_make(
            ENABLE_INSTALL
            # vcpkg_build_make passes OPTIONS to make [build] but not to make [install]; try to squeeze them in via
            # the install target instead
            INSTALL_TARGET install ${options_string}
            MAKEFILE GNUmakefile
            # Allow make to find gnustep-config, which is in bin/
            ADD_BIN_TO_PATH
            OPTIONS
                ${arg_OPTIONS}
        )
    else()
        message(FATAL_ERROR "${CMAKE_CURRENT_FUNCTION} is not implemented for your platform")
    endif()
endfunction()
