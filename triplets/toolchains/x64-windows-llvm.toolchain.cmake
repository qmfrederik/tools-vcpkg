
# Untracked since vcpkg will track the compiler version.
set(VCPKG_ENV_PASSTHROUGH_UNTRACKED "LLVMInstallDir;LLVMToolsVersion") 

# Get Program Files root to lookup possible LLVM installation
if (DEFINED ENV{ProgramW6432})
    file(TO_CMAKE_PATH "$ENV{ProgramW6432}" PROG_ROOT)
else()
    file(TO_CMAKE_PATH "$ENV{PROGRAMFILES}" PROG_ROOT)
endif()
if (DEFINED ENV{LLVMInstallDir})
    file(TO_CMAKE_PATH "$ENV{LLVMInstallDir}/bin" LLVM_BIN_DIR)
else()
    file(TO_CMAKE_PATH "${PROG_ROOT}/LLVM/bin" LLVM_BIN_DIR)
endif()

find_program(CLANG_C_EXECUTABLE NAMES "clang.exe" PATHS ${LLVM_BIN_DIR} REQUIRED)
find_program(CLANG_CXX_EXECUTABLE NAMES "clang++.exe" PATHS ${LLVM_BIN_DIR} REQUIRED)
find_program(CLANG_RC_EXECUTABLE NAMES "llvm-rc.exe" PATHS ${LLVM_BIN_DIR} REQUIRED)

set(CMAKE_C_COMPILER ${CLANG_C_EXECUTABLE} CACHE STRING "" FORCE)
set(CMAKE_CXX_COMPILER ${CLANG_CXX_EXECUTABLE} CACHE STRING "" FORCE)
set(CMAKE_RC_COMPILER  ${CLANG_RC_EXECUTABLE} CACHE STRING "" FORCE)

set(VCPKG_POLICY_SKIP_ARCHITECTURE_CHECK enabled)
set(VCPKG_POLICY_SKIP_DUMPBIN_CHECKS enabled)
set(VCPKG_LOAD_VCVARS_ENV ON)

set(VCPKG_C_FLAGS "-arch:AVX")
set(VCPKG_CXX_FLAGS "${VCPKG_C_FLAGS}")
