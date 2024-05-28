section .bss
buffer resb 20           ; Reserva 20 bytes para la cadena resultante

section .data
newline db 10            ; Carácter de nueva línea (newline)

section .text
global _start

_start:
    ; Colocar un valor en el registro RAX
    mov rax, 12345       ; Valor que queremos imprimir

    ; Llamar a la función para convertir el valor en RAX a una cadena
    mov rdi, buffer      ; Dirección del buffer para la cadena
    mov rsi, rax         ; Valor a convertir
    call itoa            ; Convertir el valor a una cadena decimal

    ; Llamada al sistema para escribir en la salida estándar
    mov rax, 1           ; syscall: write
    mov rdi, 1           ; file descriptor: stdout
    mov rsi, buffer      ; dirección de la cadena
    mov rdx, rbx         ; longitud de la cadena (almacenada en RBX por itoa)
    syscall              ; Llamar al kernel

    ; Escribir una nueva línea para mayor claridad
    mov rax, 1           ; syscall: write
    mov rdi, 1           ; file descriptor: stdout
    mov rsi, newline     ; dirección de la nueva línea
    mov rdx, 1           ; longitud de la nueva línea
    syscall              ; Llamar al kernel

    ; Llamada al sistema para salir
    mov rax, 60          ; syscall: exit
    xor edi, edi         ; código de salida: 0
    syscall              ; Llamar al kernel

itoa:                   ; Función para convertir un número en una cadena
    ; Entrada: RSI = valor, RDI = buffer
    ; Salida: RBX = longitud de la cadena
    push rbx            ; Guardar RBX en la pila
    push rcx            ; Guardar RCX en la pila
    push rdx            ; Guardar RDX en la pila
    mov rcx, 0          ; Contador de dígitos
    mov rbx, 10         ; Base decimal

itoa_loop:
    xor rdx, rdx        ; Limpiar RDX antes de DIV
    div rbx             ; Dividir RAX por 10, cociente en RAX, residuo en RDX
    add dl, '0'         ; Convertir el dígito a carácter
    push rdx            ; Guardar el dígito en la pila
    inc rcx             ; Incrementar contador de dígitos
    test rax, rax       ; Probar si RAX es 0
    jnz itoa_loop       ; Si no, repetir el bucle

    mov rbx, rcx        ; Guardar el número de dígitos en RBX
    mov rdx, rdi        ; Apuntar RDX al inicio del buffer

itoa_pop_loop:
    pop rax             ; Recuperar el siguiente dígito de la pila
    mov [rdx], al       ; Escribir el dígito en el buffer
    inc rdx             ; Moverse al siguiente carácter en el buffer
    loop itoa_pop_loop  ; Repetir hasta que todos los dígitos se hayan escrito

    mov byte [rdx], 0   ; Terminar la cadena con un null byte

    pop rdx             ; Restaurar RDX desde la pila
    pop rcx             ; Restaurar RCX desde la pila
    pop rbx             ; Restaurar RBX desde la pila
    ret                 ; Retornar de la función

