%include "glfw.inc"
%include "macros.inc"
%include "opengl.inc"

extern _ExitProcess@4
extern _Sleep@4
extern _OutputDebugStringA@4

; Predefines
NULL equ 0
GLFW_KEY_ESCAPE equ 256
GLFW_PRESS equ 1

extern write_to_console 
extern write_int_to_console 

SECTION .data
    title:          db "OpenGL Window", 0
    f1:             dd 1.0
    f0.5:           dd 0.5
    f0:             dd 0.0
    ; Background color float values for the GL window
    bgcol_red:      dd 0.5490196078431373
    bgcol_green:    dd 0.8784313725490196
    bgcol_blue:     dd 0.9803921568627451
    opening_msg:    db "Opening OpenGL x86 window", 13, 10, 0
    press_esc_msg:    db "Press the ESC key to exit", 13, 10, 0
    escape_pressed_msg:    db "Escape key pressed", 13, 10, 0
    exiting_msg:    db "Exiting program...", 13, 10, 0

SECTION .bss
    glwindow:       resd 1
    should_close:   resd 1  ; Flag to indicate if we should close the window
SECTION .text
global _main

; Key callback function
key_callback:
    push ebp
    mov ebp, esp
    ; [ebp + 8] is GLFWwindow* window
    ; [ebp + 12] is int key
    ; [ebp + 16] is int scancode
    ; [ebp + 20] is int action
    ; [ebp + 24] is int mods
    
    mov eax, [ebp + 12]  ; Get the key
    cmp eax, GLFW_KEY_ESCAPE
    jne .end_callback
    
    mov eax, [ebp + 20]  ; Get the action
    cmp eax, GLFW_PRESS
    jne .end_callback
    
    mov dword [should_close], 1  ; Set the close flag
    
.end_callback:
    push escape_pressed_msg
    call write_to_console
    mov esp, ebp
    pop ebp
    ret

; Main entry point
_main:
    ; Store stack
    cdecl_begin
    
    push opening_msg
    call write_to_console

    push press_esc_msg 
    call write_to_console

    call [glfwInit]
    test eax, eax
    jz initialization_failed

    push 0
    push 0 
    push title
    push 640
    push 640
    call [glfwCreateWindow]
    add esp, 20  ; Clean up 5 arguments * 4 bytes each
    test eax, eax
    jz window_creation_failed
    mov [glwindow], eax ; Save to variable 'glwindow'

    ; Set up key callback
    push key_callback
    push dword [glwindow]
    call [glfwSetKeyCallback]
    add esp, 8  ; Clean up arguments

    ; Set up context
    push dword [glwindow]
    call [glfwMakeContextCurrent]
    add esp, 4

mainloop:
    mov eax, [should_close]
    test eax, eax
    jnz end  ; Jump to end if should_close is set

    call gl_render ; Render the game   

    ; Swap the backbuffer to the screen buffer
    push dword [glwindow]
    call [glfwSwapBuffers]     
    add esp, 4

    ; Poll window events (e.g. resize, close)
    call [glfwPollEvents]

    push 10  ; Sleep for 10 ms to reduce CPU usage
    call _Sleep@4
    add esp, 4

    jmp mainloop

end:   
    push exiting_msg
    call write_to_console

    ; Tear down gl window
    push dword [glwindow]
    call [glfwDestroyWindow]   
    call [glfwTerminate]
    add esp, 4

    ; Restore stack
    cdecl_end

    ; Exit the process
    push 0 ; Exit code
    call _ExitProcess@4

initialization_failed:
    ; Handle initialization failure
    push 1  ; Exit code for initialization failure
    call _ExitProcess@4

window_creation_failed:
    ; Handle window creation failure
    call [glfwTerminate]
    push 2  ; Exit code for window creation failure
    call _ExitProcess@4

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
