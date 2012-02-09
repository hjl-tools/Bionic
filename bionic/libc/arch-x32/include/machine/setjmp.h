/*	$OpenBSD: setjmp.h,v 1.2 2000/08/05 22:07:32 niklas Exp $	*/
/*	$NetBSD: setjmp.h,v 1.1 1994/12/20 10:36:43 cgd Exp $	*/

/*
 * machine/setjmp.h: machine dependent setjmp-related information.
 */

/* 8 64bit registers + 32bit signal mask + 32bit signal mask save.  */
#define	_JBLEN	9		/* size, in long longs, of a jmp_buf */
