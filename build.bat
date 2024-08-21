@echo off
REM Set variables for library paths
set GLFW_PATH=C:\Users\Jackson\glfw-3.4.bin.WIN32\lib-vc2022
set WINDOWS_KIT_PATH=C:\Program Files (x86)\Windows Kits\10\lib\10.0.22621.0\um\x86
set MSVC_PATH=C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.41.34120\lib\x86
set UCRT_PATH=C:\Program Files (x86)\Windows Kits\10\lib\10.0.22621.0\ucrt\x86

REM Copy GLFW DLL
copy "%GLFW_PATH%\glfw3.dll" .

REM Ensure obj directory exists
if not exist obj mkdir obj

REM Compile all assembly files
for %%F in (src\*.asm) do (
    nasm -f win32 -i src\ -o obj\%%~nF.obj %%F
)

REM Use link for linking and generating debug symbols
link /ENTRY:main /OUT:opengl_triangle_x86.exe ^
/LIBPATH:"%GLFW_PATH%" ^
/LIBPATH:"%WINDOWS_KIT_PATH%" ^
/LIBPATH:"%MSVC_PATH%" ^
/LIBPATH:"%UCRT_PATH%" ^
obj\*.obj glfw3dll.lib opengl32.lib user32.lib kernel32.lib msvcrt.lib gdi32.lib shell32.lib legacy_stdio_definitions.lib libucrt.lib libvcruntime.lib

if %errorlevel% neq 0 (
    echo Build failed with error level %errorlevel%
    exit /b %errorlevel%
)

echo Build completed successfully.
