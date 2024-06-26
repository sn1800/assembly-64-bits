section .data
    msg db 'Hello, World!', 0

section .text
    global _start

_start:
    mov rax, 1                  ; syscall: write
    mov rdi, 1                  ; file descriptor: stdout
    mov rsi, msg                ; address of the string
    mov rdx, 13                 ; length of the string
    syscall                     ; invoke operating system to do the write

    mov rax, 60                 ; syscall: exit
    xor rdi, rdi                ; exit code 0
    syscall                     ; invoke operating system to exit
