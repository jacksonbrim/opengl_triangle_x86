%include "glfw.inc"
%include "macros.inc"
%include "opengl.inc"
; Predefines
NULL equ 0
SECTION .data
title:          db "OpenGL Game Window", 0
f1:             dd 1.0
f0.5:           dd 0.5
f0:             dd 0.0
; Background color float values for the GL window
bgcol_red:      dd 0.5490196078431373
bgcol_green:    dd 0.8784313725490196
bgcol_blue:     dd 0.9803921568627451
SECTION .bss
glwindow:       resd 1
SECTION .text
global main ; Externally accessible (linker)
; Main entry point
main:
    ; Store stack
    cdecl_begin

    call [glfwInit]

    push 0
    push 0 
    push title
    push 640
    push 640
    call [glfwCreateWindow]

    mov [glwindow], eax ; Save to variable 'glwindow'

    ; Set up context
    push eax ; glwindow
    call [glfwMakeContextCurrent]

    mainloop:
        ; Check if we should close the window
        push dword [glwindow]
        call [glfwWindowShouldClose]
        cmp eax, 1 ; If the method returns 1 (true), close
        je end ; Jump to end if true

        call gl_render ; Render the game   

        ; Swap the backbuffer to the screen buffer
        push dword [glwindow]
        call [glfwSwapBuffers]     

        ; Poll window events (e.g. resize, close)
        call [glfwPollEvents]
        jmp mainloop

    end:   

    ; Tear down gl window
    push dword [glwindow]
    call [glfwDestroyWindow]   
    call [glfwTerminate]

    ; Restore stack
    cdecl_end

    ; Return 0
    mov eax, 0
    ret

gl_render:
    cdecl_begin ; Set up stack

    ; Set up viewport at x,y,w,h
    push 480
    push 640
    push 0
    push 0
    call _glViewport@16

    push GL_COLOR_BUFFER_BIT
    call _glClear@4

    pushfloat f1 ; Alpha
    pushfloat bgcol_blue
    pushfloat bgcol_green
    pushfloat bgcol_red
    call _glClearColor@16

    render_triangle:
        push GL_TRIANGLES
        call _glBegin@4

        ; Set color to white
        pushfloat f1 ; B
        pushfloat f1 ; G
        pushfloat f1 ; R
        call _glColor3f@12

        ; Vertex A
        pushfloat f0
        pushfloat f0
        pushfloat f0
        call _glVertex3f@12

        ; Vertex B
        pushfloat f0
        pushfloat f0
        pushfloat f1
        call _glVertex3f@12

        ; Vertex C
        pushfloat f0
        pushfloat f1
        pushfloat f1
        call _glVertex3f@12

        call _glEnd@0

    cdecl_end ; Restore stack
    ret
