        %include "util.asm"

        global  _start
        section .text
_start:
        ; argc = [rsp]
        ; argv[0] = [rsp + 8 + 8 * i] for index i

        ; Check if the number of arguments is equal to 2 (./fibonacci num)
        cmp     byte [rsp], 2
        jne     Exit_Arg_Error

        mov     rdi, [rsp + 16] ; argv[0]
        call    Atoi

        mov     rdi, rax
        call    Fibonacci

        call    Print_Number

        jmp     Exit_Success

Fibonacci:
        ; rdi = n
        push    rbp
        mov     rbp, rsp

        ; if (n <= 2) return 1
        ; else goto fibonacci_recurse
        cmp     rdi, 2
        jg      .fibonacci_recurse

        mov     rax, 1
        pop     rbp
        ret

.fibonacci_recurse:
        push    rdi
        sub     rdi, 1
        call    Fibonacci
        mov     r12, rax        ; r12 = Fibonacci(n-1)
        pop     rdi
        push    rdi

        sub     rdi, 2
        call    Fibonacci
        pop     rdi

        add     rax, r12        ; rax = Fibonacci(n-1) + Fibonacci(n-2)

        pop     rbp
        ret


Exit_Arg_Error:
        mov     rdi, new_line
        call    Print_String

        mov     rdi, arg_err
        call    Print_String

        mov     rdi, new_line
        call    Print_String

        mov     rax, SYS_exit
        mov     rdi, EXIT_FAILURE
        syscall

Exit_Success:
        mov     rax, SYS_exit
        mov     rdi, EXIT_SUCCESS
        syscall
