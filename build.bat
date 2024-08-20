@echo off

REM Set variables for library paths
set GLFW_PATH=C:\Users\Jackson\glfw-3.4.bin.WIN32\lib-vc2022
set WINDOWS_KIT_PATH=C:\Program Files (x86)\Windows Kits\10\lib\10.0.22621.0\um\x86
set MSVC_PATH=C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.41.34120\lib\x86
set UCRT_PATH=C:\Program Files (x86)\Windows Kits\10\lib\10.0.22621.0\ucrt\x86

copy "%GLFW_PATH%\glfw3.dll" .

REM Compile the assembly file
nasm -f win32 -l listing.lst -i src/ -o obj/main.obj src/main.asm

REM Link the object file
link /ENTRY:main /OUT:opengl_triangle_x86.exe ^
/LIBPATH:"%GLFW_PATH%" ^
/LIBPATH:"%WINDOWS_KIT_PATH%" ^
/LIBPATH:"%MSVC_PATH%" ^
/LIBPATH:"%UCRT_PATH%" ^
obj/main.obj glfw3dll.lib opengl32.lib user32.lib kernel32.lib msvcrt.lib gdi32.lib shell32.lib legacy_stdio_definitions.lib libucrt.lib libvcruntime.lib
