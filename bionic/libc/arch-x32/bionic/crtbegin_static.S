# bionic/arch-x86/bionic/crtbegin_static.S
#
# Copyright 2006, The Android Open Source Project
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of Google Inc. nor the names of its contributors may
#       be used to endorse or promote products derived from this software
#       without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY Google Inc. ``AS IS'' AND ANY EXPRESS OR 
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO 
# EVENT SHALL Google Inc. BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; 
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

	.text
	.align 16
	.type _start, @function
	.globl _start

# this is the small startup code that is first run when
# any executable that is statically-linked with Bionic
# runs.
#
# it's purpose is to call __libc_init with appropriate
# arguments, which are:
#
#    - the address of the raw data block setup by the Linux
#      kernel ELF loader
#
#    - address of an "onexit" function, not used on any
#      platform supported by Bionic
#
#    - address of the "main" function of the program. We
#      can't hard-code it in the adr pseudo instruction
#      so we use a tiny trampoline that will get relocated
#      by the dynamic linker before this code runs
#
#    - address of the constructor list
#

_start:
	/* Extract the arguments as encoded on the stack and set up
	   the arguments for
	   
	   __libc_init (uintptr_t *elfdata, void (*atexit)(void),
			int (*main) (int, char**, char**),
			structors_array_t const * const structors);
	   The arguments are passed via registers
		elfdata:	%rdi
		atexit:		%rsi
		main:		%rdx
		structors:	%rcx
	 */

	/* Clear the frame pointer.  The ABI suggests this be done, to mark
	   the outermost frame obviously.  */
	xorl	%ebp, %ebp
	movl	%edx, %esi		# atexit
	movl	%esp, %edi		# elfdata
        mov     $0f, %edx		# main
        mov     $1f, %ecx		# structors
        call     __libc_init
0:
        jmp   main

1:  .long   __PREINIT_ARRAY__
    .long   __INIT_ARRAY__
    .long   __FINI_ARRAY__

	.section .preinit_array, "aw"
	.globl __PREINIT_ARRAY__
__PREINIT_ARRAY__:
	.long -1

	.section .init_array, "aw"
	.globl __INIT_ARRAY__
__INIT_ARRAY__:
	.long -1
	.long	frame_dummy

	.section .fini_array, "aw"
	.globl __FINI_ARRAY__
__FINI_ARRAY__:
	.long -1
	.long	__do_global_dtors_aux

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
	movl	$__deregister_frame_info, %eax
	testl	%eax, %eax
	je	.L3
	mov	$__EH_FRAME_BEGIN__, %edi
	call	__deregister_frame_info
.L3:
	movb	$1, completed.4720(%rip)
.L1:
	popq	%rbp
	ret
	.text
	.p2align 4
	.type	frame_dummy, @function
frame_dummy:
	pushq	%rbp
	movl	$__register_frame_info, %eax
	testl	%eax, %eax
	movl	%esp, %ebp
	je	.L5
	mov	$object.4725, %esi
	mov	$__EH_FRAME_BEGIN__, %edi
	call	__register_frame_info
.L5:
	popq	%rbp
	ret
	.local	completed.4720
	.comm	completed.4720,1,1
	.local	object.4725
	.comm	object.4725,24,16
	.weak	__register_frame_info
	.weak	__deregister_frame_info

#include "__dso_handle.S"
#include "atexit.S"
