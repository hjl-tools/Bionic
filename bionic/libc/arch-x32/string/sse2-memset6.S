#ifndef L
# define L(label)	.L##label
#endif

#ifndef ALIGN
# define ALIGN(n)	.p2align n
#endif

#ifndef cfi_startproc
# define cfi_startproc			.cfi_startproc
#endif

#ifndef cfi_endproc
# define cfi_endproc			.cfi_endproc
#endif

#ifndef ENTRY
# define ENTRY(name)			\
	.type name,  @function; 	\
	.globl name;			\
	.p2align 4;			\
name:					\
	cfi_startproc
#endif

#ifndef END
# define END(name)			\
	cfi_endproc;			\
	.size name, .-name
#endif

#define JMPTBL(I, B)	I - B

/* Branch to an entry in a jump table.  TABLE is a jump table with
   relative offsets.  INDEX is a register contains the index into the
   jump table.  SCALE is the scale of INDEX.  */
#define BRANCH_TO_JMPTBL_ENTRY(TABLE, INDEX, SCALE)		\
  lea		TABLE(%rip), %r11;				\
  add		INDEX, %rdi;					\
  movslq	(%r11, INDEX, SCALE), INDEX;			\
  lea		(%r11, INDEX), INDEX;				\
  jmp		*INDEX


	.section .text.sse2,"ax",@progbits
	ALIGN (4)
ENTRY (sse2_memset6)
#ifdef USE_AS_BZERO_P
	mov	%rsi, %rdx
	xor	%ecx, %ecx
#else
	movzbl	%sil, %ecx
	movb	%cl, %ch
	/* Fill the whole ECX with pattern.  */
	movl	%ecx, %esi
	shl	$16, %ecx
	or	%esi, %ecx
	mov	%rdi, %rax
#endif
	cmp	$32, %rdx
	jae	L(32bytesormore)

L(write_less32bytes):
	BRANCH_TO_JMPTBL_ENTRY (L(table_less_32bytes), %rdx, 4)


	.pushsection .rodata.sse2,"a",@progbits
	ALIGN (2)
L(table_less_32bytes):
	.int	JMPTBL (L(write_0bytes), L(table_less_32bytes))
	.int	JMPTBL (L(write_1bytes), L(table_less_32bytes))
	.int	JMPTBL (L(write_2bytes), L(table_less_32bytes))
	.int	JMPTBL (L(write_3bytes), L(table_less_32bytes))
	.int	JMPTBL (L(write_4bytes), L(table_less_32bytes))
	.int	JMPTBL (L(write_5bytes), L(table_less_32bytes))
	.int	JMPTBL (L(write_6bytes), L(table_less_32bytes))
	.int	JMPTBL (L(write_7bytes), L(table_less_32bytes))
	.int	JMPTBL (L(write_8bytes), L(table_less_32bytes))
	.int	JMPTBL (L(write_9bytes), L(table_less_32bytes))
	.int	JMPTBL (L(write_10bytes), L(table_less_32bytes))
	.int	JMPTBL (L(write_11bytes), L(table_less_32bytes))
	.int	JMPTBL (L(write_12bytes), L(table_less_32bytes))
	.int	JMPTBL (L(write_13bytes), L(table_less_32bytes))
	.int	JMPTBL (L(write_14bytes), L(table_less_32bytes))
	.int	JMPTBL (L(write_15bytes), L(table_less_32bytes))
	.int	JMPTBL (L(write_16bytes), L(table_less_32bytes))
	.int	JMPTBL (L(write_17bytes), L(table_less_32bytes))
	.int	JMPTBL (L(write_18bytes), L(table_less_32bytes))
	.int	JMPTBL (L(write_19bytes), L(table_less_32bytes))
	.int	JMPTBL (L(write_20bytes), L(table_less_32bytes))
	.int	JMPTBL (L(write_21bytes), L(table_less_32bytes))
	.int	JMPTBL (L(write_22bytes), L(table_less_32bytes))
	.int	JMPTBL (L(write_23bytes), L(table_less_32bytes))
	.int	JMPTBL (L(write_24bytes), L(table_less_32bytes))
	.int	JMPTBL (L(write_25bytes), L(table_less_32bytes))
	.int	JMPTBL (L(write_26bytes), L(table_less_32bytes))
	.int	JMPTBL (L(write_27bytes), L(table_less_32bytes))
	.int	JMPTBL (L(write_28bytes), L(table_less_32bytes))
	.int	JMPTBL (L(write_29bytes), L(table_less_32bytes))
	.int	JMPTBL (L(write_30bytes), L(table_less_32bytes))
	.int	JMPTBL (L(write_31bytes), L(table_less_32bytes))
	.popsection

	ALIGN (4)
L(write_28bytes):
	movl	%ecx, -28(%rdi)
L(write_24bytes):
	movl	%ecx, -24(%rdi)
L(write_20bytes):
	movl	%ecx, -20(%rdi)
L(write_16bytes):
	movl	%ecx, -16(%rdi)
L(write_12bytes):
	movl	%ecx, -12(%rdi)
L(write_8bytes):
	movl	%ecx, -8(%rdi)
L(write_4bytes):
	movl	%ecx, -4(%rdi)
L(write_0bytes):
	ret

	ALIGN (4)
L(write_29bytes):
	movl	%ecx, -29(%rdi)
L(write_25bytes):
	movl	%ecx, -25(%rdi)
L(write_21bytes):
	movl	%ecx, -21(%rdi)
L(write_17bytes):
	movl	%ecx, -17(%rdi)
L(write_13bytes):
	movl	%ecx, -13(%rdi)
L(write_9bytes):
	movl	%ecx, -9(%rdi)
L(write_5bytes):
	movl	%ecx, -5(%rdi)
L(write_1bytes):
	movb	%cl, -1(%rdi)
	ret

	ALIGN (4)
L(write_30bytes):
	movl	%ecx, -30(%rdi)
L(write_26bytes):
	movl	%ecx, -26(%rdi)
L(write_22bytes):
	movl	%ecx, -22(%rdi)
L(write_18bytes):
	movl	%ecx, -18(%rdi)
L(write_14bytes):
	movl	%ecx, -14(%rdi)
L(write_10bytes):
	movl	%ecx, -10(%rdi)
L(write_6bytes):
	movl	%ecx, -6(%rdi)
L(write_2bytes):
	movw	%cx, -2(%rdi)
	ret

	ALIGN (4)
L(write_31bytes):
	movl	%ecx, -31(%rdi)
L(write_27bytes):
	movl	%ecx, -27(%rdi)
L(write_23bytes):
	movl	%ecx, -23(%rdi)
L(write_19bytes):
	movl	%ecx, -19(%rdi)
L(write_15bytes):
	movl	%ecx, -15(%rdi)
L(write_11bytes):
	movl	%ecx, -11(%rdi)
L(write_7bytes):
	movl	%ecx, -7(%rdi)
L(write_3bytes):
	movw	%cx, -3(%rdi)
	movb	%cl, -1(%rdi)
	ret

	ALIGN (4)
/* RDX > 32 and RDI is 4 byte aligned.  */
L(32bytesormore):
	/* Fill xmm0 with the pattern.  */
#ifdef USE_AS_BZERO_P
	pxor	%xmm0, %xmm0
#else
	movd	%ecx, %xmm0
	punpcklbw %xmm0, %xmm0
	pshufd	$0, %xmm0, %xmm0
#endif
	testl	$0xf, %edi
	jz	L(aligned_16)
/* RDX > 32 and RDI is not 16 byte aligned.  */
	movdqu	%xmm0, (%rdi)
	mov	%rdi, %rsi
	and	$-16, %rdi
	add	$16, %rdi
	sub	%rdi, %rsi
	add	%rsi, %rdx

	ALIGN (4)
L(aligned_16):
	cmp	$128, %rdx
	jge	L(128bytesormore)

L(aligned_16_less128bytes):
	BRANCH_TO_JMPTBL_ENTRY (L(table_16_128bytes), %rdx, 4)

	ALIGN (4)
L(128bytesormore):
#ifdef SHARED_CACHE_SIZE
	cmp	$SHARED_CACHE_SIZE, %edx
#else
	cmp	__x86_64_shared_cache_size(%rip), %edx
#endif
	jg	L(128bytesormore_nt)

L(128bytesormore_normal):
	sub	$128, %rdx
	movdqa	%xmm0, (%rdi)
	movdqa	%xmm0, 0x10(%rdi)
	movdqa	%xmm0, 0x20(%rdi)
	movdqa	%xmm0, 0x30(%rdi)
	movdqa	%xmm0, 0x40(%rdi)
	movdqa	%xmm0, 0x50(%rdi)
	movdqa	%xmm0, 0x60(%rdi)
	movdqa	%xmm0, 0x70(%rdi)
	lea	128(%rdi), %rdi
	cmp	$128, %rdx
	jl	L(128bytesless_normal)


	sub	$128, %rdx
	movdqa	%xmm0, (%rdi)
	movdqa	%xmm0, 0x10(%rdi)
	movdqa	%xmm0, 0x20(%rdi)
	movdqa	%xmm0, 0x30(%rdi)
	movdqa	%xmm0, 0x40(%rdi)
	movdqa	%xmm0, 0x50(%rdi)
	movdqa	%xmm0, 0x60(%rdi)
	movdqa	%xmm0, 0x70(%rdi)
	lea	128(%rdi), %rdi
	cmp	$128, %rdx
	jl	L(128bytesless_normal)


	sub	$128, %rdx
	movdqa	%xmm0, (%rdi)
	movdqa	%xmm0, 0x10(%rdi)
	movdqa	%xmm0, 0x20(%rdi)
	movdqa	%xmm0, 0x30(%rdi)
	movdqa	%xmm0, 0x40(%rdi)
	movdqa	%xmm0, 0x50(%rdi)
	movdqa	%xmm0, 0x60(%rdi)
	movdqa	%xmm0, 0x70(%rdi)
	lea	128(%rdi), %rdi
	cmp	$128, %rdx
	jl	L(128bytesless_normal)


	sub	$128, %rdx
	movdqa	%xmm0, (%rdi)
	movdqa	%xmm0, 0x10(%rdi)
	movdqa	%xmm0, 0x20(%rdi)
	movdqa	%xmm0, 0x30(%rdi)
	movdqa	%xmm0, 0x40(%rdi)
	movdqa	%xmm0, 0x50(%rdi)
	movdqa	%xmm0, 0x60(%rdi)
	movdqa	%xmm0, 0x70(%rdi)
	lea	128(%rdi), %rdi
	cmp	$128, %rdx
	jge	L(128bytesormore_normal)

L(128bytesless_normal):
	BRANCH_TO_JMPTBL_ENTRY (L(table_16_128bytes), %rdx, 4)

	ALIGN (4)
L(128bytesormore_nt):
	sub	$128, %rdx
	movntdq	%xmm0, (%rdi)
	movntdq	%xmm0, 0x10(%rdi)
	movntdq	%xmm0, 0x20(%rdi)
	movntdq	%xmm0, 0x30(%rdi)
	movntdq	%xmm0, 0x40(%rdi)
	movntdq	%xmm0, 0x50(%rdi)
	movntdq	%xmm0, 0x60(%rdi)
	movntdq	%xmm0, 0x70(%rdi)
	lea	128(%rdi), %rdi
	cmp	$128, %rdx
	jge	L(128bytesormore_nt)
	sfence
	BRANCH_TO_JMPTBL_ENTRY (L(table_16_128bytes), %rdx, 4)

	.pushsection .rodata.sse2,"a",@progbits
	ALIGN (2)
L(table_16_128bytes):
	.int	JMPTBL (L(aligned_16_0bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_1bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_2bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_3bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_4bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_5bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_6bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_7bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_8bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_9bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_10bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_11bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_12bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_13bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_14bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_15bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_16bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_17bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_18bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_19bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_20bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_21bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_22bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_23bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_24bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_25bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_26bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_27bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_28bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_29bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_30bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_31bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_32bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_33bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_34bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_35bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_36bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_37bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_38bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_39bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_40bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_41bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_42bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_43bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_44bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_45bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_46bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_47bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_48bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_49bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_50bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_51bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_52bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_53bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_54bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_55bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_56bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_57bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_58bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_59bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_60bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_61bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_62bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_63bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_64bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_65bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_66bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_67bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_68bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_69bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_70bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_71bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_72bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_73bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_74bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_75bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_76bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_77bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_78bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_79bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_80bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_81bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_82bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_83bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_84bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_85bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_86bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_87bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_88bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_89bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_90bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_91bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_92bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_93bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_94bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_95bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_96bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_97bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_98bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_99bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_100bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_101bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_102bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_103bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_104bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_105bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_106bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_107bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_108bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_109bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_110bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_111bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_112bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_113bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_114bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_115bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_116bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_117bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_118bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_119bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_120bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_121bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_122bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_123bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_124bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_125bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_126bytes), L(table_16_128bytes))
	.int	JMPTBL (L(aligned_16_127bytes), L(table_16_128bytes))
	.popsection

	ALIGN (4)
L(aligned_16_112bytes):
	movdqa	%xmm0, -112(%rdi)
L(aligned_16_96bytes):
	movdqa	%xmm0, -96(%rdi)
L(aligned_16_80bytes):
	movdqa	%xmm0, -80(%rdi)
L(aligned_16_64bytes):
	movdqa	%xmm0, -64(%rdi)
L(aligned_16_48bytes):
	movdqa	%xmm0, -48(%rdi)
L(aligned_16_32bytes):
	movdqa	%xmm0, -32(%rdi)
L(aligned_16_16bytes):
	movdqa	%xmm0, -16(%rdi)
L(aligned_16_0bytes):
	ret

	ALIGN (4)
L(aligned_16_113bytes):
	movdqa	%xmm0, -113(%rdi)
L(aligned_16_97bytes):
	movdqa	%xmm0, -97(%rdi)
L(aligned_16_81bytes):
	movdqa	%xmm0, -81(%rdi)
L(aligned_16_65bytes):
	movdqa	%xmm0, -65(%rdi)
L(aligned_16_49bytes):
	movdqa	%xmm0, -49(%rdi)
L(aligned_16_33bytes):
	movdqa	%xmm0, -33(%rdi)
L(aligned_16_17bytes):
	movdqa	%xmm0, -17(%rdi)
L(aligned_16_1bytes):
	movb	%cl, -1(%rdi)
	ret

	ALIGN (4)
L(aligned_16_114bytes):
	movdqa	%xmm0, -114(%rdi)
L(aligned_16_98bytes):
	movdqa	%xmm0, -98(%rdi)
L(aligned_16_82bytes):
	movdqa	%xmm0, -82(%rdi)
L(aligned_16_66bytes):
	movdqa	%xmm0, -66(%rdi)
L(aligned_16_50bytes):
	movdqa	%xmm0, -50(%rdi)
L(aligned_16_34bytes):
	movdqa	%xmm0, -34(%rdi)
L(aligned_16_18bytes):
	movdqa	%xmm0, -18(%rdi)
L(aligned_16_2bytes):
	movw	%cx, -2(%rdi)
	ret

	ALIGN (4)
L(aligned_16_115bytes):
	movdqa	%xmm0, -115(%rdi)
L(aligned_16_99bytes):
	movdqa	%xmm0, -99(%rdi)
L(aligned_16_83bytes):
	movdqa	%xmm0, -83(%rdi)
L(aligned_16_67bytes):
	movdqa	%xmm0, -67(%rdi)
L(aligned_16_51bytes):
	movdqa	%xmm0, -51(%rdi)
L(aligned_16_35bytes):
	movdqa	%xmm0, -35(%rdi)
L(aligned_16_19bytes):
	movdqa	%xmm0, -19(%rdi)
L(aligned_16_3bytes):
	movw	%cx, -3(%rdi)
	movb	%cl, -1(%rdi)
	ret

	ALIGN (4)
L(aligned_16_116bytes):
	movdqa	%xmm0, -116(%rdi)
L(aligned_16_100bytes):
	movdqa	%xmm0, -100(%rdi)
L(aligned_16_84bytes):
	movdqa	%xmm0, -84(%rdi)
L(aligned_16_68bytes):
	movdqa	%xmm0, -68(%rdi)
L(aligned_16_52bytes):
	movdqa	%xmm0, -52(%rdi)
L(aligned_16_36bytes):
	movdqa	%xmm0, -36(%rdi)
L(aligned_16_20bytes):
	movdqa	%xmm0, -20(%rdi)
L(aligned_16_4bytes):
	movl	%ecx, -4(%rdi)
	ret

	ALIGN (4)
L(aligned_16_117bytes):
	movdqa	%xmm0, -117(%rdi)
L(aligned_16_101bytes):
	movdqa	%xmm0, -101(%rdi)
L(aligned_16_85bytes):
	movdqa	%xmm0, -85(%rdi)
L(aligned_16_69bytes):
	movdqa	%xmm0, -69(%rdi)
L(aligned_16_53bytes):
	movdqa	%xmm0, -53(%rdi)
L(aligned_16_37bytes):
	movdqa	%xmm0, -37(%rdi)
L(aligned_16_21bytes):
	movdqa	%xmm0, -21(%rdi)
L(aligned_16_5bytes):
	movl	%ecx, -5(%rdi)
	movb	%cl, -1(%rdi)
	ret

	ALIGN (4)
L(aligned_16_118bytes):
	movdqa	%xmm0, -118(%rdi)
L(aligned_16_102bytes):
	movdqa	%xmm0, -102(%rdi)
L(aligned_16_86bytes):
	movdqa	%xmm0, -86(%rdi)
L(aligned_16_70bytes):
	movdqa	%xmm0, -70(%rdi)
L(aligned_16_54bytes):
	movdqa	%xmm0, -54(%rdi)
L(aligned_16_38bytes):
	movdqa	%xmm0, -38(%rdi)
L(aligned_16_22bytes):
	movdqa	%xmm0, -22(%rdi)
L(aligned_16_6bytes):
	movl	%ecx, -6(%rdi)
	movw	%cx, -2(%rdi)
	ret

	ALIGN (4)
L(aligned_16_119bytes):
	movdqa	%xmm0, -119(%rdi)
L(aligned_16_103bytes):
	movdqa	%xmm0, -103(%rdi)
L(aligned_16_87bytes):
	movdqa	%xmm0, -87(%rdi)
L(aligned_16_71bytes):
	movdqa	%xmm0, -71(%rdi)
L(aligned_16_55bytes):
	movdqa	%xmm0, -55(%rdi)
L(aligned_16_39bytes):
	movdqa	%xmm0, -39(%rdi)
L(aligned_16_23bytes):
	movdqa	%xmm0, -23(%rdi)
L(aligned_16_7bytes):
	movl	%ecx, -7(%rdi)
	movw	%cx, -3(%rdi)
	movb	%cl, -1(%rdi)
	ret

	ALIGN (4)
L(aligned_16_120bytes):
	movdqa	%xmm0, -120(%rdi)
L(aligned_16_104bytes):
	movdqa	%xmm0, -104(%rdi)
L(aligned_16_88bytes):
	movdqa	%xmm0, -88(%rdi)
L(aligned_16_72bytes):
	movdqa	%xmm0, -72(%rdi)
L(aligned_16_56bytes):
	movdqa	%xmm0, -56(%rdi)
L(aligned_16_40bytes):
	movdqa	%xmm0, -40(%rdi)
L(aligned_16_24bytes):
	movdqa	%xmm0, -24(%rdi)
L(aligned_16_8bytes):
	movq	%xmm0, -8(%rdi)
	ret

	ALIGN (4)
L(aligned_16_121bytes):
	movdqa	%xmm0, -121(%rdi)
L(aligned_16_105bytes):
	movdqa	%xmm0, -105(%rdi)
L(aligned_16_89bytes):
	movdqa	%xmm0, -89(%rdi)
L(aligned_16_73bytes):
	movdqa	%xmm0, -73(%rdi)
L(aligned_16_57bytes):
	movdqa	%xmm0, -57(%rdi)
L(aligned_16_41bytes):
	movdqa	%xmm0, -41(%rdi)
L(aligned_16_25bytes):
	movdqa	%xmm0, -25(%rdi)
L(aligned_16_9bytes):
	movq	%xmm0, -9(%rdi)
	movb	%cl, -1(%rdi)
	ret

	ALIGN (4)
L(aligned_16_122bytes):
	movdqa	%xmm0, -122(%rdi)
L(aligned_16_106bytes):
	movdqa	%xmm0, -106(%rdi)
L(aligned_16_90bytes):
	movdqa	%xmm0, -90(%rdi)
L(aligned_16_74bytes):
	movdqa	%xmm0, -74(%rdi)
L(aligned_16_58bytes):
	movdqa	%xmm0, -58(%rdi)
L(aligned_16_42bytes):
	movdqa	%xmm0, -42(%rdi)
L(aligned_16_26bytes):
	movdqa	%xmm0, -26(%rdi)
L(aligned_16_10bytes):
	movq	%xmm0, -10(%rdi)
	movw	%cx, -2(%rdi)
	ret

	ALIGN (4)
L(aligned_16_123bytes):
	movdqa	%xmm0, -123(%rdi)
L(aligned_16_107bytes):
	movdqa	%xmm0, -107(%rdi)
L(aligned_16_91bytes):
	movdqa	%xmm0, -91(%rdi)
L(aligned_16_75bytes):
	movdqa	%xmm0, -75(%rdi)
L(aligned_16_59bytes):
	movdqa	%xmm0, -59(%rdi)
L(aligned_16_43bytes):
	movdqa	%xmm0, -43(%rdi)
L(aligned_16_27bytes):
	movdqa	%xmm0, -27(%rdi)
L(aligned_16_11bytes):
	movq	%xmm0, -11(%rdi)
	movw	%cx, -3(%rdi)
	movb	%cl, -1(%rdi)
	ret

	ALIGN (4)
L(aligned_16_124bytes):
	movdqa	%xmm0, -124(%rdi)
L(aligned_16_108bytes):
	movdqa	%xmm0, -108(%rdi)
L(aligned_16_92bytes):
	movdqa	%xmm0, -92(%rdi)
L(aligned_16_76bytes):
	movdqa	%xmm0, -76(%rdi)
L(aligned_16_60bytes):
	movdqa	%xmm0, -60(%rdi)
L(aligned_16_44bytes):
	movdqa	%xmm0, -44(%rdi)
L(aligned_16_28bytes):
	movdqa	%xmm0, -28(%rdi)
L(aligned_16_12bytes):
	movq	%xmm0, -12(%rdi)
	movl	%ecx, -4(%rdi)
	ret

	ALIGN (4)
L(aligned_16_125bytes):
	movdqa	%xmm0, -125(%rdi)
L(aligned_16_109bytes):
	movdqa	%xmm0, -109(%rdi)
L(aligned_16_93bytes):
	movdqa	%xmm0, -93(%rdi)
L(aligned_16_77bytes):
	movdqa	%xmm0, -77(%rdi)
L(aligned_16_61bytes):
	movdqa	%xmm0, -61(%rdi)
L(aligned_16_45bytes):
	movdqa	%xmm0, -45(%rdi)
L(aligned_16_29bytes):
	movdqa	%xmm0, -29(%rdi)
L(aligned_16_13bytes):
	movq	%xmm0, -13(%rdi)
	movl	%ecx, -5(%rdi)
	movb	%cl, -1(%rdi)
	ret

	ALIGN (4)
L(aligned_16_126bytes):
	movdqa	%xmm0, -126(%rdi)
L(aligned_16_110bytes):
	movdqa	%xmm0, -110(%rdi)
L(aligned_16_94bytes):
	movdqa	%xmm0, -94(%rdi)
L(aligned_16_78bytes):
	movdqa	%xmm0, -78(%rdi)
L(aligned_16_62bytes):
	movdqa	%xmm0, -62(%rdi)
L(aligned_16_46bytes):
	movdqa	%xmm0, -46(%rdi)
L(aligned_16_30bytes):
	movdqa	%xmm0, -30(%rdi)
L(aligned_16_14bytes):
	movq	%xmm0, -14(%rdi)
	movl	%ecx, -6(%rdi)
	movw	%cx, -2(%rdi)
	ret

	ALIGN (4)
L(aligned_16_127bytes):
	movdqa	%xmm0, -127(%rdi)
L(aligned_16_111bytes):
	movdqa	%xmm0, -111(%rdi)
L(aligned_16_95bytes):
	movdqa	%xmm0, -95(%rdi)
L(aligned_16_79bytes):
	movdqa	%xmm0, -79(%rdi)
L(aligned_16_63bytes):
	movdqa	%xmm0, -63(%rdi)
L(aligned_16_47bytes):
	movdqa	%xmm0, -47(%rdi)
L(aligned_16_31bytes):
	movdqa	%xmm0, -31(%rdi)
L(aligned_16_15bytes):
	movq	%xmm0, -15(%rdi)
	movl	%ecx, -7(%rdi)
	movw	%cx, -3(%rdi)
	movb	%cl, -1(%rdi)
	ret

END (sse2_memset6)
