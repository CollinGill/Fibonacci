        section .data
; -----
; Define standard constants. 
LF              equ     10                ; line feed
NULL            equ     0                 ; end of string
TRUE            equ     1
FALSE           equ     0 
EXIT_SUCCESS    equ     0                 ; success code

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
        
        global  _start
        section .text
_start:
        ; argc = [esp]
        ; argv = [esp + 4 * i] 1-indexed

        mov     rdi, hello
        call    Print_String

        jmp     Exit_Success

Exit_Success:
        mov     rax, SYS_exit
        mov     rdi, EXIT_SUCCESS
        syscall

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