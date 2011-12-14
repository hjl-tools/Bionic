/*-
 * Copyright (c) 2004-2005 David Schultz <das@FreeBSD.ORG>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 * $FreeBSD: src/lib/msun/amd64/fenv.c,v 1.3 2005/03/16 19:03:45 das Exp $
 */

#include <sys/cdefs.h>
#include <sys/types.h>
#include <machine/fpu.h>
#include <fenv.h>

/*
 * As compared to the x87 control word, the SSE unit's control word
 * has the rounding control bits offset by 3 and the exception mask
 * bits offset by 7.
 */
#define	_SSE_ROUND_SHIFT	3
#define	_SSE_EMASK_SHIFT	7

const fenv_t __fe_dfl_env = {
	{ 0xffff0000 | __INITIAL_FPUCW__,
	  0xffff0000,
	  0xffffffff,
	  { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0xff }
	},
	__INITIAL_MXCSR__
};

#define __fldcw(__cw)           __asm __volatile("fldcw %0" : : "m" (__cw))
#define __fldenv(__env)         __asm __volatile("fldenv %0" : : "m" (__env))
#define	__fldenvx(__env)	__asm __volatile("fldenv %0" : : "m" (__env)  \
				: "st", "st(1)", "st(2)", "st(3)", "st(4)",   \
				"st(5)", "st(6)", "st(7)")
#define __fnclex()              __asm __volatile("fnclex")
#define __fnstenv(__env)        __asm __volatile("fnstenv %0" : "=m" (*(__env)))
#define __fnstcw(__cw)          __asm __volatile("fnstcw %0" : "=m" (*(__cw)))
#define __fnstsw(__sw)          __asm __volatile("fnstsw %0" : "=am" (*(__sw)))
#define __fwait()               __asm __volatile("fwait")
#define __ldmxcsr(__csr)        __asm __volatile("ldmxcsr %0" : : "m" (__csr))
#define __stmxcsr(__csr)        __asm __volatile("stmxcsr %0" : "=m" (*(__csr)))

int
fesetexceptflag(const fexcept_t *flagp, int excepts)
{
	fenv_t env;

	excepts &= FE_ALL_EXCEPT;
	if (excepts) { /* Do nothing if excepts is 0 */
		__fnstenv(&env.__x87);
		env.__x87.__status &= ~excepts;
		env.__x87.__status |= *flagp & excepts;
		__fnclex();
		__fldenv(env.__x87);
		__stmxcsr(&env.__mxcsr);
		env.__mxcsr &= ~excepts;
		env.__mxcsr |= *flagp & excepts;
		__ldmxcsr(env.__mxcsr);
	}

	return (0);
}

int
feraiseexcept(int excepts)
{
	fexcept_t ex = excepts;

	fesetexceptflag(&ex, excepts);
	__fwait();
	return (0);
}

int
fegetenv(fenv_t *envp)
{
	__fnstenv(&envp->__x87);
	/*
	 * fnstenv masks all exceptions, so we need to restore
	 * the old control word to avoid this side effect.
	 */
	__fldcw(envp->__x87.__control);
	__stmxcsr(&envp->__mxcsr);
	return (0);
}

int
feholdexcept(fenv_t *envp)
{
	__uint32_t mxcsr;

	__fnstenv(&envp->__x87);
	envp->__x87.__status &= ~FE_ALL_EXCEPT;
	envp->__x87.__control |= FE_ALL_EXCEPT;
	__fnclex();
	__fldenv(envp->__x87);
	__stmxcsr(&mxcsr);
	envp->__mxcsr = mxcsr;
	mxcsr &= ~FE_ALL_EXCEPT;
	mxcsr |= FE_ALL_EXCEPT << _SSE_EMASK_SHIFT;
	__ldmxcsr(mxcsr);
	return (0);
}

int
feupdateenv(const fenv_t *envp)
{
	__uint32_t mxcsr;
	__uint16_t status;

	__fnstsw(&status);
	__stmxcsr(&mxcsr);
	fesetenv(envp);
	feraiseexcept((mxcsr | status) & FE_ALL_EXCEPT);
	return (0);
}

int
feenableexcept(int mask)
{
	__uint32_t mxcsr;
	__uint16_t control, omask;

	mask &= FE_ALL_EXCEPT;
	__fnstcw(&control);
	__stmxcsr(&mxcsr);
	omask = ~(control | mxcsr >> _SSE_EMASK_SHIFT) & FE_ALL_EXCEPT;
	if (mask) {
		control &= ~mask;
		__fldcw(control);
		mxcsr &= ~(mask << _SSE_EMASK_SHIFT);
		__ldmxcsr(mxcsr);
	}
	return (omask);
}

int
fedisableexcept(int mask)
{
	__uint32_t mxcsr;
	__uint16_t control, omask;

	mask &= FE_ALL_EXCEPT;
	__fnstcw(&control);
	__stmxcsr(&mxcsr);
	omask = ~(control | mxcsr >> _SSE_EMASK_SHIFT) & FE_ALL_EXCEPT;
	if (mask) {
		control |= mask;
		__fldcw(control);
		mxcsr |= mask << _SSE_EMASK_SHIFT;
		__ldmxcsr(mxcsr);
	}
	return (omask);
}

int
feclearexcept(int excepts)
{
	fenv_t env;

	excepts &= FE_ALL_EXCEPT;
	if (excepts) { /* Do nothing if excepts is 0 */
		__fnstenv(&env.__x87);
		env.__x87.__status &= ~excepts;
		__fnclex();
		__fldenv(env.__x87);
		__stmxcsr(&env.__mxcsr);
		env.__mxcsr &= ~excepts;
		__ldmxcsr(env.__mxcsr);
	}
	return (0);
}

int
fegetexceptflag(fexcept_t *flagp, int excepts)
{
	__uint32_t mxcsr;
	__uint16_t status;

	excepts &= FE_ALL_EXCEPT;
	__fnstsw(&status);
	__stmxcsr(&mxcsr);
	*flagp = (status | mxcsr) & excepts;
	return (0);
}

int
fetestexcept(int excepts)
{
	__uint32_t mxcsr;
	__uint16_t status;

	excepts &= FE_ALL_EXCEPT;
	if (excepts) { /* Do nothing if excepts is 0 */
		__fnstsw(&status);
		__stmxcsr(&mxcsr);
		return ((status | mxcsr) & excepts);
	}
	return (0);
}

int
fegetround(void)
{
	__uint16_t control;

	/*
	 * We assume that the x87 and the SSE unit agree on the
	 * rounding mode.  Reading the control word on the x87 turns
	 * out to be about 5 times faster than reading it on the SSE
	 * unit on an Opteron 244.
	 */
	__fnstcw(&control);
	return (control & _ROUND_MASK);
}

int
fesetround(int round)
{
	__uint32_t mxcsr;
	__uint16_t control;

	if (round & ~_ROUND_MASK) {
		return (-1);
	} else {
		__fnstcw(&control);
		control &= ~_ROUND_MASK;
		control |= round;
		__fldcw(control);
		__stmxcsr(&mxcsr);
		mxcsr &= ~(_ROUND_MASK << _SSE_ROUND_SHIFT);
		mxcsr |= round << _SSE_ROUND_SHIFT;
		__ldmxcsr(mxcsr);
		return (0);
	}
}

int
fesetenv(const fenv_t *envp)
{
	/*
	 * XXX Using fldenvx() instead of fldenv() tells the compiler that this
	 * instruction clobbers the i387 register stack.  This happens because
	 * we restore the tag word from the saved environment.  Normally, this
	 * would happen anyway and we wouldn't care, because the ABI allows
	 * function calls to clobber the i387 regs.  However, fesetenv() is
	 * inlined, so we need to be more careful.
	 */
	__fldenvx(envp->__x87);
	__ldmxcsr(envp->__mxcsr);
	return (0);
}

int
fegetexcept(void)
{
	__uint16_t control;

	/*
	 * We assume that the masks for the x87 and the SSE unit are
	 * the same.
	 */
	__fnstcw(&control);
	return (~control & FE_ALL_EXCEPT);
}
