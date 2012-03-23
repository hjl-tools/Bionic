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
	movl	%esi, %eax		/* save tls */
	andl	$~15, %esi		/* align stack to 16byte */
	movl 	%eax, -8(%rsi)		/* tls */
	movl 	%ecx, -12(%rsi)		/* arg */
	movl 	%edi, -16(%rsi)		/* fn */

	sub	$16, %esi		/* new stack */
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
        # with the appropriate arguments in registers.
	movl	(%rsp), %edi		/* fn */
	movl	4(%rsp), %esi		/* arg */
	movl	8(%rsp), %edx		/* tls */
	# keep stack 16byte aligned
	leal	16(%rsp), %esp
        call    __thread_entry
        hlt

2:
        ret

/* XXX: TODO: Add __bionic_clone here
 *            See bionic/bionic_clone.c and arch-arm/bionic/clone.S
 *            for more details...
 */
