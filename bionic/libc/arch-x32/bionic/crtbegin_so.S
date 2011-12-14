/*
 * Copyright (C) 2008 The Android Open Source Project
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *  * Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *  * Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
 * AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

.section .init_array, "aw"
.align 4
.type __INIT_ARRAY__, @object
.globl __INIT_ARRAY__
__INIT_ARRAY__:
    .long -1
    .long frame_dummy

.section .fini_array, "aw"
.align 4
.type __FINI_ARRAY__, @object
.globl __FINI_ARRAY__
__FINI_ARRAY__:
    .long -1
    .long __do_global_dtors_aux

	.section	.eh_frame,"a",@progbits
	.align 4
	.type	__EH_FRAME_BEGIN__, @object
__EH_FRAME_BEGIN__:
	.text
	.p2align 4
	.type	__do_global_dtors_aux, @function
__do_global_dtors_aux:
	cmpb	$0, completed.4720(%rip)
	pushq	%rbp
	movl	%esp, %ebp
	jne	.L1
	mov	__dso_handle(%rip), %edi
	call	__cxa_finalize@PLT
	cmpl	$0, __deregister_frame_info@GOTPCREL(%rip)
	je	.L4
	leal	__EH_FRAME_BEGIN__(%rip), %edi
	call	__deregister_frame_info@PLT
.L4:
	movb	$1, completed.4720(%rip)
.L1:
	popq	%rbp
	ret
	.text
	.p2align 4
	.type	frame_dummy, @function
frame_dummy:
	cmpl	$0, __register_frame_info@GOTPCREL(%rip)
	pushq	%rbp
	movl	%esp, %ebp
	je	.L6
	leal	object.4725(%rip), %esi
	leal	__EH_FRAME_BEGIN__(%rip), %edi
	call	__register_frame_info@PLT
.L6:
	popq	%rbp
	ret
	.local	completed.4720
	.comm	completed.4720,1,1
	.local	object.4725
	.comm	object.4725,24,16
	.weak	__register_frame_info
	.weak	__deregister_frame_info

#include "__dso_handle_so.S"
#include "atexit.S"
