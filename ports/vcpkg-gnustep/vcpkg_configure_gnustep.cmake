include_guard(GLOBAL)

set(Z_VCPKG_CMAKE_GET_VARS_CURRENT_LIST_DIR "${CMAKE_CURRENT_LIST_DIR}" CACHE INTERNAL "")

function(vcpkg_configure_gnustep)
    cmake_parse_arguments(PARSE_ARGV 0 "arg"
        ""
        "SOURCE_PATH"
        "OPTIONS"
    )

    if (VCPKG_TARGET_IS_LINUX)
        vcpkg_configure_make(
            SOURCE_PATH ${arg_SOURCE_PATH}
            # This would pass --disable-silent-rules, which is not supported by the GNUstep build system
            DISABLE_VERBOSE_FLAGS
            # Allow ./configure to find gnustep-config, which is in bin/
            ADD_BIN_TO_PATH
            # GNUstep does not support out-of-tree builds
            COPY_SOURCE
            OPTIONS
                ${arg_OPTIONS}
        )
    else()
        message(FATAL_ERROR "${CMAKE_CURRENT_FUNCTION} is not implemented for your platform")
    endif()
endfunction()
