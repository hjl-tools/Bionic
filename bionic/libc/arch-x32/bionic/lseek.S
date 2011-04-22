#include <sys/linux-syscalls.h>

    .text
    .type lseek, @function
    .globl lseek
    .align 16

lseek:
    movl    $__NR_lseek, %eax
    syscall
    cmp     $-4095, %eax
    jb      1f
    negl    %eax
    movl    %eax, %edi
    call    __set_errno
    orl     $-1, %eax
1:
    ret

    .globl lseek64
lseek64 = lseek
