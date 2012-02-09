/* $OpenBSD: setjmp.S,v 1.8 2005/08/07 11:30:38 espie Exp $ */
/*-
 * Copyright (c) 1990 The Regents of the University of California.
 * All rights reserved.
 *
 * This code is derived from software contributed to Berkeley by
 * William Jolitz.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

#include <machine/asm.h>

/*
 * C library -- setjmp, longjmp
 *
 *	longjmp(a,v)
 * will generate a "return(v)" from the last call to
 *	setjmp(a)
 * by restoring registers from the stack.
 * The previous signal state is restored.
 */

ENTRY(setjmp)
	/* Save RDI */
	pushq	%rdi
	movl	$0, %edi
#ifdef PIC
	call	PIC_PLT(_C_LABEL(sigblock))
#else
	call	_C_LABEL(sigblock)
#endif
	/* Restor RDI */
	popq	%rdi

	/* Get return address */
	movq	0(%rsp),%rdx
	movq	%rdx, 0(%rdi)
	movq	%rbx, 8(%rdi)
	movq	%rsp,16(%rdi)
	movq	%rbp,24(%rdi)
	movq	%r12,32(%rdi)
	movq	%r13,40(%rdi)
	movq	%r14,48(%rdi)
	movq	%r15,56(%rdi)
	/* Store signal mask */
	movl	%eax,64(%rdi)
	xorl	%eax,%eax
	ret

ENTRY(longjmp)
	/* Save RDI */
	pushq	%rdi
	/* Save RSI */
	pushq	%rsi
	/* Get the stored signal mask */
	movl	64(%rdi), %edi
#ifdef PIC
	call	PIC_PLT(_C_LABEL(sigsetmask))
#else
	call	_C_LABEL(sigsetmask)
#endif
	/* Restor RSI */
	popq	%rsi
	/* Restor RDI */
	popq	%rdi

	/* Load the return value */
	movl	%esi,%eax
	/* Get PC */
	movq	0(%rdi),%rdx
	movq	8(%rdi),%rbx
	movq	16(%rdi),%rsp
	movq	24(%rdi),%rbp
	movq	32(%rdi),%r12
	movq	40(%rdi),%r13
	movq	48(%rdi),%r14
	movq	56(%rdi),%r15
	testl	%eax,%eax
	jnz	1f
	incl	%eax
1:	movq	%rdx,0(%rsp)	/* Update return address */
	ret
