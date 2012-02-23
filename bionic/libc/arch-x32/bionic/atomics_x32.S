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
    mov     %edx, %r10d           /* timeout */
    mov     %esi, %edx           /* val */
    movl    $FUTEX_WAIT, %esi
    movl    $__NR_futex, %eax
    syscall
    ret


/* int __futex_wake(volatile void *ftx, int count) */

.text
.globl __futex_wake
.type __futex_wake, @function
.align 16
__futex_wake:
    mov     %esi, %edx           /* count */
    movl    $FUTEX_WAKE, %esi
    movl    $__NR_futex, %eax
    syscall
    ret

/* int __futex_syscall3(volatile void *ftx, int op, int count) */
.text
.globl __futex_syscall3
.type __futex_syscall3, @function
.align 16
__futex_syscall3:
    movl    $__NR_futex, %eax
    syscall
    ret

/* int __futex_syscall4(volatile void *ftx, int op, int val, const struct timespec *timeout) */
.text
.globl __futex_syscall4
.type __futex_syscall4, @function
.align 16
__futex_syscall4:
    mov     %ecx, %r10d
    movl    $__NR_futex, %eax
    syscall
    ret
