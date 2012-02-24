#include <sys/linux-syscalls.h>

.text

/*
 * int  __pthread_clone(int (*fn)(void*), void **tls, int flags,
 *                      void *arg);
 */
.globl __pthread_clone
.type __pthread_clone, @function
.align 16
__pthread_clone:
        # insert arguments onto the child stack and keep stack 16byte
	# aligned.
	movq 	%rsi, -16(%rsi)		/* tls */
	movq 	%rcx, -24(%rsi)		/* arg */
	movq 	%rdi, -32(%rsi)		/* fn */

	sub	$32, %esi		/* new stack */
        movl    %edx, %edi		/* flags */
        movl    $__NR_clone, %eax
	syscall
        test    %eax, %eax
        jns     1f

        # an error occured, set errno and return -1
        negl    %eax
	movl	%eax, %edi
        call    __set_errno
        orl     $-1, %eax
        jmp     2f

1:
        jnz     2f

        # we're in the child thread now, call __thread_entry
        # with the appropriate arguments on the child stack
        # we already placed most of them
	popq	%rdi
	popq	%rsi
	popq	%rdx
        jmp     __thread_entry
        hlt

2:
        ret

/* XXX: TODO: Add __bionic_clone here
 *            See bionic/bionic_clone.c and arch-arm/bionic/clone.S
 *            for more details...
 */
