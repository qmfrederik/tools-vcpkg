set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE dynamic)

set(VCPKG_CMAKE_SYSTEM_NAME Linux)

# GNUstep stores part of its build configuration in /share, which is shared across both the
# release and debug builds in vcpkg.  This effectively breaks support for debug builds, for now.
set(VCPKG_BUILD_TYPE release)

# Configure toolchain
set(VCPKG_CHAINLOAD_TOOLCHAIN_FILE "${CMAKE_CURRENT_LIST_DIR}/toolchains/x64-linux-llvm.toolchain.cmake")

set(VCPKG_FIXUP_ELF_RPATH ON)
