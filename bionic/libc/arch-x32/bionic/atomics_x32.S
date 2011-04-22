#include <sys/linux-syscalls.h>

#define FUTEX_WAIT 0
#define FUTEX_WAKE 1


/*
 * int __futex_wait(volatile void *ftx, int val, const struct timespec *timeout)
 */
.text
.globl __futex_wait
.type __futex_wait, @function
.align 16
__futex_wait:
    pushq   %rbx
    mov     %edi, %ebx           /* ftx */
    movl    $FUTEX_WAIT, %ecx
    mov     %esi, %edx           /* val */
    mov     %edx, %esi           /* timeout */
    movl    $__NR_futex, %eax
    int     $0x80
    popq    %rbx
    ret


/* int __futex_wake(volatile void *ftx, int count) */

.text
.globl __futex_wake
.type __futex_wake, @function
.align 16
__futex_wake:
    pushq   %rbx
    mov     %edi, %ebx           /* ftx */
    movl    $FUTEX_WAKE, %ecx
    mov     %esi, %edx           /* count */
    movl    $__NR_futex, %eax
    int     $0x80
    popq    %rbx
    ret

/* int __futex_syscall3(volatile void *ftx, int op, int count) */
.text
.globl __futex_syscall3
.type __futex_syscall3, @function
.align 16
__futex_syscall3:
    pushq   %rbx
    mov     %edi, %ebx           /* ftx */
    movl    %esi, %ecx      /* op */
    movl    $__NR_futex, %eax
    int     $0x80
    popq    %rbx
    ret

/* int __futex_syscall4(volatile void *ftx, int op, int val, const struct timespec *timeout) */
.text
.globl __futex_syscall4
.type __futex_syscall4, @function
.align 16
__futex_syscall4:
    pushq   %rbx
    mov     %edi, %ebx           /* ftx */
    xchg    %esi, %ecx		 /* fix op and timeout */
    movl    $__NR_futex, %eax
    int     $0x80
    popq    %rbx
    ret
