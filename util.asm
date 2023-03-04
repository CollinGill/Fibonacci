        section .data
; -----
; Define standard constants. 
LF              equ     10                ; line feed
NULL            equ     0                 ; end of string
TRUE            equ     1
FALSE           equ     0 
EXIT_SUCCESS    equ     0                 ; success code
EXIT_FAILURE    equ     1                 ; failure code

STDIN           equ     0                 ; standard input
STDOUT          equ     1                 ; standard output
STDERR          equ     2                 ; standard error

SYS_read        equ     0                 ; read
SYS_write       equ     1                 ; write
SYS_open        equ     2                 ; file open
SYS_close       equ     3                 ; file close
SYS_fork        equ     57                ; fork
SYS_exit        equ     60                ; terminate
SYS_creat       equ     85                ; file open/create
SYS_time        equ     201               ; get time

; -----
; Newline
new_line:       db      LF, NULL
arg_err:        db      "ERROR: Need exactly 1 argument", 0xA, 0x0
atoi_err:       db      "ERROR: Input is not an integer", 0xA, 0x0
buf:           db      "0000000000", 0xA, 0x0
        
        section .text
; -----
; Get length of null-terminated string
Strlen:
        push    rbp
        mov     rbp, rsp

        xor     rax, rax
.strlen_loop:
        cmp     byte [rdi + rax], NULL
        je      .strlen_done

        inc     rax
        jmp     .strlen_loop

.strlen_done:
        pop     rbp
        ret

; -----
; Print a null-terminated string
Print_String:
        push    rbp
        mov     rbp, rsp

        push    rdi
        call    Strlen 

        pop     rsi
        mov     rdx, rax
        mov     rax, SYS_write
        mov     rdi, STDOUT
        syscall

        pop     rbp
        ret

; -----
; Convert an integer in an ASCII string to an integer
Atoi:
        push    rbp
        mov     rbp, rsp        ; Stack frame

        xor     rax, rax        ; Clear result
.atoi_loop:
        movzx   rcx, byte [rdi]
        inc     rdi

        ; Exit loop if the current ASCII character is less than '0' or above '9'
        cmp     rcx, NULL
        je      .atoi_done

        cmp     rcx, '0'
        jb      .atoi_error

        cmp     rcx, '9'
        ja      .atoi_error

        ; Convert character to an integer
        sub     rcx, '0'
        imul    rax, 10         ; Multiply current result by ten 
        add     rax, rcx        ; Add current digit to result

        jmp     .atoi_loop

.atoi_done:
        pop     rbp
        ret

.atoi_error:
        mov     rdi, new_line
        call    Print_String

        mov     rdi, atoi_err
        call    Print_String

        mov     rax, SYS_exit
        mov     rdi, EXIT_FAILURE
        syscall

Print_Number:
        push    rbp
        mov     rbp, rsp

        mov     rbx, buf + 9
        mov     rcx, 10
        mov     rdi, 10
.print_number_loop:
        mov     rdx, 0
        div     rdi
        add     rdx, '0'
        mov     [rbx], dl
        dec     rbx
        loop   .print_number_loop

        mov     rax, SYS_write
        mov     rdi, STDOUT
        mov     rsi, buf
        mov     rdx, 11
        syscall

        pop     rbp
        ret
