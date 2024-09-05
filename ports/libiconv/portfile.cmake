vcpkg_download_distfile(ARCHIVE
    URLS "https://ftp.gnu.org/gnu/libiconv/libiconv-${VERSION}.tar.gz"
         "https://www.mirrorservice.org/sites/ftp.gnu.org/gnu/libiconv/libiconv-${VERSION}.tar.gz"
    FILENAME "libiconv-${VERSION}.tar.gz"
    SHA512 18a09de2d026da4f2d8b858517b0f26d853b21179cf4fa9a41070b2d140030ad9525637dc4f34fc7f27abca8acdc84c6751dfb1d426e78bf92af4040603ced86
)

vcpkg_extract_source_archive(
    SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
    PATCHES
)

vcpkg_list(SET OPTIONS)
if(VCPKG_TARGET_IS_WINDOWS)
    vcpkg_acquire_msys(MSYS_ROOT
        PACKAGES
            bash
            autoconf-wrapper
            automake-wrapper
            which
            binutils
            libtool
            make
            pkgconf
    )

    z_vcpkg_get_cmake_vars(cmake_vars_file)
    debug_message("Including cmake vars from: ${cmake_vars_file}")
    include("${cmake_vars_file}")

    set(base_cmd "${MSYS_ROOT}/usr/bin/bash.exe" --noprofile --norc --debug)

    vcpkg_list(APPEND path_list "${MSYS_ROOT}/usr/bin")

    get_filename_component(LLVM_PATH ${VCPKG_DETECTED_CMAKE_C_COMPILER} DIRECTORY)
    vcpkg_list(APPEND path_list "${LLVM_PATH}")

    # Cleanup previous build dirs
    file(REMOVE_RECURSE "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-${short_name_RELEASE}"
                        "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-${short_name_DEBUG}"
                        "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}")

    # Some PATH handling for dealing with spaces....some tools will still fail with that!
    # In particular, the libtool install command is unable to install correctly to paths with spaces.
    string(REPLACE " " "\\ " current_installed_dir_escaped "${CURRENT_INSTALLED_DIR}")
    set(current_installed_dir_msys "${CURRENT_INSTALLED_DIR}")

    if(CMAKE_HOST_WIN32)
        string(REGEX REPLACE "^([a-zA-Z]):/" "/\\1/" current_installed_dir_msys "${current_installed_dir_msys}")
    endif()

    # Set configure paths
    set(path_suffix "/")

    vcpkg_list(APPEND CONFIGURE_OPTIONS
                        # ${prefix} has an extra backslash to prevent early expansion when calling `bash -c configure "..."`.
                        "--prefix=${current_installed_dir_msys}${path_suffix}"
                        # Important: These should all be relative to prefix!
                        "--bindir=\\\${prefix}/../tools/${PORT}${path_suffix}/bin"
                        "--sbindir=\\\${prefix}/../tools/${PORT}${path_suffix}/sbin"
                        "--libdir=\\\${prefix}/lib" # On some Linux distributions lib64 is the default
                        "--datarootdir=\\\${prefix}/share/${PORT}"
                        # https://gitlab.gnome.org/GNOME/libxml2/-/issues/69#note_539141
                        "--build=x86_64-pc-windows"
                        "--host=x86_64-pc-windows"
                        "--target=x86_64-pc-windows"
                        # Insists on building static libraries, though
                        "--enable-shared"
                        "--disable-static"
                        "CC=clang.exe"
                        "CXX=clang++.exe"
                        "LD=ld.lld.exe"
                        "LDFLAGS=-fuse-ld=lld"
                        "LIBTOOL=libtool.exe"
                        #"CFLAGS=\"-DFFI_STATIC_BUILD -fms-extensions\""
                    )

    # Add gnustep-make to path so we can run gnustep-config
    vcpkg_list(APPEND path_list "${CURRENT_INSTALLED_DIR}/${path_suffix}/bin")

    cmake_path(CONVERT "${path_list}" TO_NATIVE_PATH_LIST native_path_list)
    set(ENV{PATH} "${native_path_list}")
    message("Using path ${native_path_list}")

    list(JOIN CONFIGURE_OPTIONS " " CONFIGURE_OPTIONS)

    vcpkg_execute_required_process(
        COMMAND ${base_cmd} -c "./configure ${CONFIGURE_OPTIONS}"
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

    # Rename libffi.a to ffi.lib; may work to:
    # set LIBEXT=".lib"
    # set 
    file(RENAME "${CURRENT_INSTALLED_DIR}/lib/libiconv.a" "${CURRENT_INSTALLED_DIR}/lib/iconv.lib")
    file(REMOVE "${CURRENT_INSTALLED_DIR}/lib/libiconv.la")
endif()
