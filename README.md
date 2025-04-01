<!---
{
  "depends_on": ["https://github.com/STEMgraph/116c995e-c4b7-40f5-b84f-068474bbb87c"],
  "author": "Stephan Bökelmann",
  "first_used": "2025-04-01",
  "keywords": ["NASM", "syscall", "read", "write", "file descriptor", "ASCII", "Linux"]
}
--->

# Reading, Modifying, and Printing a Character with NASM

## 1) Introduction

In [previous exercises](https://github.com/STEMgraph/116c995e-c4b7-40f5-b84f-068474bbb87c), we learned how to exit a program and print text using the `write` syscall. Now, we’ll add a new system call to the mix: `read`.

This time, your program will:

1. Open a file (`./assets/data`)
2. Read a single byte
3. Increment the ASCII value of that byte
4. Write the result to the terminal

This is a great introduction to **file I/O** and **basic data manipulation** in assembly.

---

## Required Syscalls

| Syscall     | Number | Purpose       |
|-------------|--------|---------------|
| `open`      | 2      | Open a file   |
| `read`      | 0      | Read from a file descriptor |
| `write`     | 1      | Write to a file descriptor  |
| `exit`      | 60     | Exit program  |

For `open`, you need to pass a pointer to the filename and a flag (`O_RDONLY = 0`).

---

## Example Code Skeleton

```nasm
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
```

Make sure the file `./assets/data` exists and contains exactly **1 ASCII character**.

---

## 2) Tasks

1. **Set Up File**: Create the file `./assets/data` and insert a single character like `A`.
2. **Assemble and Run**: Build the assembly program and run it. You should see the next ASCII character (e.g., `B`).
3. **Test Edge Cases**: What happens with `Z`, `9`, or `~`?
4. **Try Reading More**: Modify the buffer to read 2 bytes and print both incremented.

---

## 3) Questions

1. What is the file descriptor returned by `open`? Why do we save it in `r12`?
2. Why do we pass `0` as the second argument to `open()`?
3. How would you read more than one byte and increment each?
4. What happens if the file doesn’t exist?
5. What’s the difference between ASCII `'A' + 1` and ASCII `'9' + 1`?

<details>
  <summary>Hint: ASCII Table</summary>

  Use [ASCII Table Reference](https://www.asciitable.com/) to understand what values you're manipulating.
</details>

---

## 4) Advice

File I/O and byte manipulation are fundamental tasks in systems programming. Unlike high-level languages, assembly leaves no room for assumptions — every step must be precise. Always check your syscall numbers, registers, and memory layout.

Also, get into the habit of creating your own minimal test files. The Linux shell is your best friend here:

```bash
echo -n A > ./assets/data
```

Let me know if you want a version with error checking or a follow-up that handles more than one byte!
