#include <sys/linux-syscalls.h>

    .text
    .type mmap, @function
    .globl mmap
    .align 16

mmap:
    mov     %rcx, %r10
    movl    $__NR_mmap, %eax
    syscall
    cmp     $-4095, %eax
    jb      1f
    negl    %eax
    movl    %eax, %edi
    call    __set_errno
    orl     $-1, %eax
1:
    ret
