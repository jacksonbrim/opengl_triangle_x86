SECTION .data
    int_buffer times 11 db 0  ; Buffer to hold the string representation of the integer

SECTION .text
global write_int_to_console
extern write_to_console

write_int_to_console:
    push ebp
    mov ebp, esp
    push eax        ; Preserve eax
    push ebx
    push ecx
    push edx
    push esi
    push edi

    mov ecx, [ebp + 8]  ; Get the integer argument
    mov edi, int_buffer
    add edi, 10         ; Start from the end of the buffer
    mov ebx, 10         ; Divisor

    .convert_loop:
        xor edx, edx    ; Clear EDX for division
        mov eax, ecx    ; Move the current value to eax for division
        div ebx         ; Divide EAX by 10, quotient in EAX, remainder in EDX
        mov ecx, eax    ; Store the quotient back in ecx
        add dl, '0'     ; Convert remainder to ASCII
        dec edi         ; Move back in the buffer
        mov [edi], dl   ; Store the digit
        test ecx, ecx   ; Check if we're done
        jnz .convert_loop

    ; EDI now points to the start of our number string
    push edi
    call write_to_console
    add esp, 4  ; Clean up after write_to_console

    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax         ; Restore eax
    mov esp, ebp
    pop ebp
    ret 4  ; Clean up the stack (4 bytes for the pushed integer)
