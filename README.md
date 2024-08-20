# OpenGL Triangle in x86 Assembly

This project demonstrates how to create a simple OpenGL triangle using x86 assembly language with the NASM assembler for Windows.

## Prerequisites

Before you begin, ensure you have the following installed:

1. [The Netwide Assembler (NASM)](https://nasm.us/)
2. Visual Studio Build Tools
3. [GLFW 3.4 (32-bit version)](https://www.glfw.org/download.html)

## Setup

1. Open the x86 Developer Command Prompt for Visual Studio. This ensures you're using the 32-bit versions of the build tools.

2. Navigate to the project directory.

3. Modify the `build.bat` file:
   - Open `build.bat` in a text editor.
   - Update the path variables at the top of the file to match your system configuration.

### Path Variables

The `build.bat` file contains the following path variables that you need to set:

- `GLFW_PATH`: Path to the GLFW library (32-bit version).
- `WINDOWS_KIT_PATH`: Path to the Windows Kit libraries.
- `MSVC_PATH`: Path to the Microsoft Visual C++ libraries.
- `UCRT_PATH`: Path to the Universal C Runtime libraries.

The `build.bat` file will automatially copy the glfw3dll.lib into the root directory containing the executable.

These paths may vary depending on your specific Visual Studio version and installation location.

## Building the Project

After setting up the path variables:

1. Run the `build.bat` file by typing `build.bat` in the command prompt.
2. This will compile the assembly code and link it with the necessary libraries to create the executable.

## Running the Project

After successful compilation, you should find an executable named `opengl_triangle_x86.exe` in your project directory. Run it to see the OpenGL triangle.

