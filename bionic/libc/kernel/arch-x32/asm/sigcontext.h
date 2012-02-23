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
#ifndef _ASM_X32_SIGCONTEXT_H
#define _ASM_X32_SIGCONTEXT_H

#include <linux/compiler.h>
#include <asm/types.h>

#ifdef __i386__

struct _fpreg {
 unsigned short significand[4];
 unsigned short exponent;
};

struct _fpxreg {
 unsigned short significand[4];
 unsigned short exponent;
 unsigned short padding[3];
};

struct _xmmreg {
 unsigned long element[4];
};

struct _fpstate {

 unsigned long cw;
 unsigned long sw;
 unsigned long tag;
 unsigned long ipoff;
 unsigned long cssel;
 unsigned long dataoff;
 unsigned long datasel;
 struct _fpreg _st[8];
 unsigned short status;
 unsigned short magic;

 unsigned long _fxsr_env[6];
 unsigned long mxcsr;
 unsigned long reserved;
 struct _fpxreg _fxsr_st[8];
 struct _xmmreg _xmm[8];
 unsigned long padding[56];
};

#define X86_FXSR_MAGIC 0x0000

struct sigcontext {
 unsigned short gs, __gsh;
 unsigned short fs, __fsh;
 unsigned short es, __esh;
 unsigned short ds, __dsh;
 unsigned long edi;
 unsigned long esi;
 unsigned long ebp;
 unsigned long esp;
 unsigned long ebx;
 unsigned long edx;
 unsigned long ecx;
 unsigned long eax;
 unsigned long trapno;
 unsigned long err;
 unsigned long eip;
 unsigned short cs, __csh;
 unsigned long eflags;
 unsigned long esp_at_signal;
 unsigned short ss, __ssh;
 struct _fpstate __user * fpstate;
 unsigned long oldmask;
 unsigned long cr2;
};

#else

struct _fpstate {
 __u16 cwd;
 __u16 swd;
 __u16 twd;
 __u16 fop;
 __u64 rip;
 __u64 rdp;
 __u32 mxcsr;
 __u32 mxcsr_mask;
 __u32 st_space[32];
 __u32 xmm_space[64];
 __u32 reserved2[24];
};

struct sigcontext {
 unsigned long r8;
 unsigned long long r9;
 unsigned long long r10;
 unsigned long long r11;
 unsigned long long r12;
 unsigned long long r13;
 unsigned long long r14;
 unsigned long long r15;
 unsigned long long rdi;
 unsigned long long rsi;
 unsigned long long rbp;
 unsigned long long rbx;
 unsigned long long rdx;
 unsigned long long rax;
 unsigned long long rcx;
 unsigned long long rsp;
 unsigned long long rip;
 unsigned long long eflags;
 unsigned short cs;
 unsigned short gs;
 unsigned short fs;
 unsigned short __pad0;
 unsigned long long err;
 unsigned long long trapno;
 unsigned long long oldmask;
 unsigned long long cr2;
 struct _fpstate __user *fpstate;
#ifndef __LP64__
 unsigned int __fpstate_pad;
#endif
 unsigned long long reserved1[8];
};

#endif

#endif
