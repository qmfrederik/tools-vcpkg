string(REPLACE "." "_" MAKE_VERSION ${VERSION})

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO gnustep/libs-base
    REF "base-${MAKE_VERSION}"
    SHA512 f656ad73138e476874fa70c5fa74718b023e97314e80d3a75ec7f25efe90d11a8dd6dd5d18706797e7be590f53300e9adb031bba3c85fdf9fd909dbf0d57b08e
    HEAD_REF master
    PATCHES
)

vcpkg_configure_gnustep(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        # GNUstep.conf contains absolute paths, and doesn't exist in vcpkg
        --disable-importing-config-file
        # gnustep-config is not in PATH, so specify the path to the makefiles
        GNUSTEP_MAKEFILES=${CURRENT_INSTALLED_DIR}/share/GNUstep/Makefiles/
)

vcpkg_install_gnustep()

vcpkg_fixup_pkgconfig()

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING.LIB")