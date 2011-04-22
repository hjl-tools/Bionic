/*
 * Generic syscall call.
 * Upon entry
 *	%eax: system call number
 *	%ebx: arg0 to system call
 *	%ecx: arg..
 *	%edx: arg..
 *	%esi: arg..
 *	%edi: arg..
 * We push these (to save them) load them up with the
 * values from the calling frame (not all will actually be valid)
 * and make the syscall.
 */

#include <sys/linux-syscalls.h>

    .text
    .type syscall, @function
    .globl syscall
    .align 16

syscall:
    push    %rbp
    push    %rbx
    mov     %edi,%eax
    mov     %esi,%ebx
    xchg    %edx, %ecx
    mov     %r8d,%esi
    mov     %r9d,%edi
    mov     24(%rsp),%ebp

    int     $0x80

    cmpl    $-129, %eax
    jb      1f
    negl    %eax
    movl    %eax, %esi
    call    __set_errno
    orl     $-1, %eax
1:
    pop    %rbx
    pop    %rbp
    ret
