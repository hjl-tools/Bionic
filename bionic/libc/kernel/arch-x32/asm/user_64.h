/****************************************************************************
 ****************************************************************************
 ***
 ***   This header was automatically generated from a Linux kernel header
 ***   of the same name, to make information necessary for userspace to
 ***   call into the kernel available to libc.  It contains only constants,
 ***   structures, and macros generated from the original header, and thus,
 ***   contains no copyrightable information.
 ***
 ****************************************************************************
 ****************************************************************************/
#ifndef _I386_USER_H
#define _I386_USER_H

#include <asm/page.h>

struct user_i387_struct {
	unsigned short	cwd;
	unsigned short	swd;
	unsigned short	twd;
	unsigned short	fop;
	__u64	rip;
	__u64	rdp;
	__u32	mxcsr;
	__u32	mxcsr_mask;
	__u32	st_space[32];
	__u32	xmm_space[64];
	__u32	padding[24];
};

struct user_regs_struct {
	unsigned long long	r15;
	unsigned long long	r14;
	unsigned long long	r13;
	unsigned long long	r12;
	unsigned long long	bp;
	unsigned long long	bx;
	unsigned long long	r11;
	unsigned long long	r10;
	unsigned long long	r9;
	unsigned long long	r8;
	unsigned long long	ax;
	unsigned long long	cx;
	unsigned long long	dx;
	unsigned long long	si;
	unsigned long long	di;
	unsigned long long	orig_ax;
	unsigned long long	ip;
	unsigned long long	cs;
	unsigned long long	flags;
	unsigned long long	sp;
	unsigned long long	ss;
	unsigned long long	fs_base;
	unsigned long long	gs_base;
	unsigned long long	ds;
	unsigned long long	es;
	unsigned long long	fs;
	unsigned long long	gs;
};

struct user {
  struct user_regs_struct regs;
  int u_fpvalid;
  struct user_i387_struct i387;
  unsigned long long int u_tsize;
  unsigned long long int u_dsize;
  unsigned long long int u_ssize;
  unsigned long long start_code; 
  unsigned long long start_stack;
  long long int signal;
  int reserved;
  unsigned long u_ar0;
  int pad0;
  struct user_i387_struct *u_fpstate;
  int pad1;
  unsigned long long magic;
  char u_comm[32];
  unsigned long long u_debugreg[8];
};

#define NBPG PAGE_SIZE
#define UPAGES 1
#define HOST_TEXT_START_ADDR (u.start_code)
#define HOST_STACK_END_ADDR (u.start_stack + u.u_ssize * NBPG)

#endif
