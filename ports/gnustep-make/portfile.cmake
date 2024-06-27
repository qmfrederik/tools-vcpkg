string(REPLACE "." "_" MAKE_VERSION ${VERSION})

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO gnustep/tools-make
    REF "make-${MAKE_VERSION}"
    SHA512 ec1a21a36cd39d354dc1ed88e2c0b576ae5418af562f6ecb66619442d967a22b0eb7dee9914cfe4430674ca0c409d5755df76308a7c90af64ab9dbeaf9b85b28
    HEAD_REF master
    PATCHES
)

vcpkg_list(SET OPTIONS)
if(VCPKG_TARGET_IS_WINDOWS)
    vcpkg_acquire_msys(MSYS_ROOT
        PACKAGES
            bash
    )
    vcpkg_add_to_path("${MSYS_ROOT}/usr/bin")
    vcpkg_list(APPEND OPTIONS "-DBASH_EXECUTABLE=${MSYS_ROOT}/usr/bin/bash.exe")
endif()

# Get the Windows 10 include location (which we need to pass to MSYS)
get_filename_component(WINKIT_ROOT "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows Kits\\Installed Roots;KitsRoot10]" ABSOLUTE CACHE)
file(GLOB WINKIT_LIB_CANDIDATES "${WINKIT_ROOT}/Lib/*")
list(GET WINKIT_LIB_CANDIDATES 0 WINKIT_LIB_CANDIDATE)
get_filename_component(WINKIT_LIB "${WINKIT_LIB_CANDIDATE}/um/x64" ABSOLUTE CACHE)
# # Escape spaces
# string(REPLACE " " "\\ " WINKIT_LIB "${WINKIT_LIB}")
# # Fix path
# string(REGEX REPLACE "^([a-zA-Z]):/" "/\\1/" WINKIT_LIB "${WINKIT_LIB}")

#set(ENV{LDFLAGS} "-fuse-ld=lld -L\'${WINKIT_LIB}\'")

vcpkg_configure_make(
    AUTOCONFIG
    OPTIONS --target=x86_64-pc-windows --host=x86_64-pc-windows LDFLAGS=\"-fuse-ld=lld -L\"${WINKIT_LIB}\"\"
    SOURCE_PATH ${SOURCE_PATH}
)

vcpkg_build_make(BUILD_TARGET compile)
vcpkg_build_make(BUILD_TARGET install)
