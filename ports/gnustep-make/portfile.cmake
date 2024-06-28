string(REPLACE "." "_" MAKE_VERSION ${VERSION})

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO gnustep/tools-make
    REF "make-${MAKE_VERSION}"
    SHA512 ec1a21a36cd39d354dc1ed88e2c0b576ae5418af562f6ecb66619442d967a22b0eb7dee9914cfe4430674ca0c409d5755df76308a7c90af64ab9dbeaf9b85b28
    HEAD_REF master
    PATCHES
)

# Get the Windows 10 include location (which we need to pass to MSYS)
get_filename_component(WINKIT_ROOT "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows Kits\\Installed Roots;KitsRoot10]" ABSOLUTE CACHE)
file(GLOB WINKIT_LIB_CANDIDATES "${WINKIT_ROOT}/Lib/*")
list(GET WINKIT_LIB_CANDIDATES 0 WINKIT_LIB_CANDIDATE)
get_filename_component(WINKIT_LIB "${WINKIT_LIB_CANDIDATE}/um/x64" ABSOLUTE CACHE)

vcpkg_list(SET OPTIONS)
if(VCPKG_TARGET_IS_WINDOWS)
    vcpkg_acquire_msys(MSYS_ROOT
        PACKAGES
            bash
            autoconf-wrapper
            automake-wrapper
            binutils
            libtool
            make
            pkgconf
            which
    )

    z_vcpkg_get_cmake_vars(cmake_vars_file)
    debug_message("Including cmake vars from: ${cmake_vars_file}")
    include("${cmake_vars_file}")

    set(base_cmd "${MSYS_ROOT}/usr/bin/bash.exe" --noprofile --norc --debug)

    vcpkg_list(APPEND path_list "${MSYS_ROOT}/usr/bin")

    get_filename_component(LLVM_PATH ${VCPKG_DETECTED_CMAKE_C_COMPILER} DIRECTORY)
    vcpkg_list(APPEND path_list "${LLVM_PATH}")

    cmake_path(CONVERT "${path_list}" TO_NATIVE_PATH_LIST native_path_list)
    set(ENV{PATH} "${native_path_list}")
    message("Using path ${native_path_list}")

    vcpkg_execute_required_process(
        COMMAND ${base_cmd} -c "./configure CC=clang.exe CXX=clang++.exe"
        WORKING_DIRECTORY "${SOURCE_PATH}"
        LOGNAME "config-${TARGET_TRIPLET}-${short_name_${current_buildtype}}"
        SAVE_LOG_FILES config.log
    )
    
    vcpkg_execute_required_process(
        COMMAND ${base_cmd} -c "make"
        LOGNAME "make-${TARGET_TRIPLET}-${short_name_${current_buildtype}}"
        WORKING_DIRECTORY "${SOURCE_PATH}"
    )
    
    vcpkg_execute_required_process(
        COMMAND ${base_cmd} -c "make install"
        LOGNAME "install-${TARGET_TRIPLET}-${short_name_${current_buildtype}}"
        WORKING_DIRECTORY "${SOURCE_PATH}"
    )
endif()
