@echo off

robocopy %RECIPE_DIR%\.. . /E /NFL

mkdir build
cd build

if %ARCH%==32 (
    set CMAKE_CONFIG="Release|Win32"
)
if %ARCH%==64 (
    set CMAKE_CONFIG="Release|x64"
)

cmake .. ^
 -DBUILD_SHARED_LIBS=1 ^
 -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX%

cmake --build . --config %CMAKE_CONFIG% --target ALL_BUILD
cmake --build . --config %CMAKE_CONFIG% --target INSTALL

if errorlevel 1 exit 1
