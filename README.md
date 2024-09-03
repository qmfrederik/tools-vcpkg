# Cross-platform build tools for GNUstep

This repository contains [VCPKG](https://vcpkg.io/) port files for building [GNUstep](https://gnustep.github.io/) on Windows and Linux.

On Windows, this repository takes the approach of building GNUstep using the Windows-native LLVM (clang) compiler.
While it uses MSYS2 to get a Bash shell, which allows running the scripts required to configure and build GNUstep,
it does not use the MSYS2 compiler toolchain.

## Getting started on Windows

On Windows, you'll need to download the Windows SDK and the LLVM toolchain.  Optionally, you can use Visual Studio Code
as an editor and Git for source code interations.

- [Visual Studio 2022 Build Tools (Windows SDK)](https://visualstudio.microsoft.com/downloads/)
- [LLVM](https://releases.llvm.org/download.html)
- [Visual Studio Code](https://code.visualstudio.com/Download)
- [Git for Windows](https://git-scm.com/download/win)

To get started, first bootstrap your vcpkg installation:

```ps
.\bootstrap-vcpkg.bat
```

Then, you can run `vcpkg` to install any GNUstep component.  You'll need to specify the `x64-windows-llvm` triplet
to make sure GNUstep is built using LLVM:

```
.\vcpkg.exe install libobjc2:x64-windows-llvm
```
