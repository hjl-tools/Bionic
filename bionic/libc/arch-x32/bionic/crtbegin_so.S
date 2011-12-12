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
