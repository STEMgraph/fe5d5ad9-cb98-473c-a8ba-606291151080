section .data
    path    db "./assets/data", 0
    buffer  db 0               ; space to store the read byte

section .text
    global _start

_start:
    ; open(path, O_RDONLY)
    mov     rax, 2              ; syscall: open
    mov     rdi, path           ; filename
    xor     rsi, rsi            ; flags = O_RDONLY
    syscall
    mov     r12, rax            ; save file descriptor

    ; read(fd, buffer, 1)
    mov     rax, 0              ; syscall: read
    mov     rdi, r12            ; file descriptor
    mov     rsi, buffer         ; destination
    mov     rdx, 1              ; read 1 byte
    syscall

    ; increment ASCII value
    inc     byte [buffer]

    ; write(stdout, buffer, 1)
    mov     rax, 1              ; syscall: write
    mov     rdi, 1              ; stdout
    mov     rsi, buffer         ; pointer to data
    mov     rdx, 1              ; length = 1
    syscall

    ; exit(0)
    mov     rax, 60
    xor     rdi, rdi
    syscall