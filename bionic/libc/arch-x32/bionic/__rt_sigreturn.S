#include <asm/unistd_x32.h>

    .text
    .type __rt_sigreturn, @function
    .globl __rt_sigreturn
    .align 16

__rt_sigreturn:
    movl    $__NR_rt_sigreturn, %eax
    syscall
