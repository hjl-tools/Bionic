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
    mov     %edi,%eax
    mov     %rsi,%rdi
    mov     %rdx,%rsi
    mov     %rcx,%rdx
    mov     %r8,%r10
    mov     %r9,%r8
    mov     8(%rsp),%r9
    syscall
    cmp     $-4095, %eax
    jb      1f
    negl    %eax
    movl    %eax, %edi
    call    __set_errno
    orl     $-1, %eax
1:
    ret
