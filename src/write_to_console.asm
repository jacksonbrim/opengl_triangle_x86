%include "win.inc"

section .data
    STD_OUTPUT_HANDLE equ -11

section .bss
    console_handle resd 1
    bytes_written resd 1

section .text
global write_to_console

write_to_console:
    push ebp
    mov ebp, esp
    push ebx
    push esi
    push edi

    ; Get the handle to the console
    push STD_OUTPUT_HANDLE
    call _GetStdHandle@4

    mov [console_handle], eax

    ; Calculate string length
    mov esi, [ebp + 8]  ; First argument (string pointer)
    xor ecx, ecx        ; Clear ECX to use as counter
    .strlen_loop:
        lodsb           ; Load byte from ESI into AL and increment ESI
        test al, al     ; Check if we've reached the null terminator
        jz .strlen_done
        inc ecx         ; Increment counter
        jmp .strlen_loop
    .strlen_done:

    ; Write to console
    push 0              ; lpReserved (NULL)
    push bytes_written  ; lpNumberOfCharsWritten
    push ecx            ; nNumberOfCharsToWrite
    push dword [ebp + 8] ; lpBuffer
    push dword [console_handle] ; hConsoleOutput
    call _WriteConsoleA@20

    ; Flush the buffer
    push dword [console_handle]
    call _FlushFileBuffers@4

    pop edi
    pop esi
    pop ebx
    mov esp, ebp
    pop ebp
    ret 4  ; Clean up the stack (4 bytes for the pushed string pointer)
