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
#ifndef _ASM_X86_PTRACE_ABI_H
#define _ASM_X86_PTRACE_ABI_H

#ifdef __i386__

#define EBX 0
#define ECX 1
#define EDX 2
#define ESI 3
#define EDI 4
#define EBP 5
#define EAX 6
#define DS 7
#define ES 8
#define FS 9
#define GS 10
#define ORIG_EAX 11
#define EIP 12
#define CS 13
#define EFL 14
#define UESP 15
#define SS 16
#define FRAME_SIZE 17

#else

#if defined(__ASSEMBLY__) || defined(__FRAME_OFFSETS)
#define R15 0
#define R14 8
#define R13 16
#define R12 24
#define RBP 32
#define RBX 40

#define R11 48
#define R10 56
#define R9 64
#define R8 72
#define RAX 80
#define RCX 88
#define RDX 96
#define RSI 104
#define RDI 112
#define ORIG_RAX 120  

#define RIP 128
#define CS 136
#define EFLAGS 144
#define RSP 152
#define SS 160
#define ARGOFFSET R11
#else
/* For x86-64, similar to i386.  Used in C code.  */
#define R15	0
#define R14	1
#define R13	2
#define R12	3
#define RBP	4
#define RBX	5
#define R11	6
#define R10	7
#define R9	8
#define R8	9
#define RAX	10
#define RCX	11
#define RDX	12
#define RSI	13
#define RDI	14
#define ORIG_RAX 15
#define RIP	16
#define CS	17
#define EFLAGS	18
#define RSP	19
#define SS	20
#define FS_BASE 21
#define GS_BASE 22
#define DS	23
#define ES	24
#define FS	25
#define GS	26
#endif

#define FRAME_SIZE 168

#endif

#define PTRACE_GETREGS 12
#define PTRACE_SETREGS 13
#define PTRACE_GETFPREGS 14
#define PTRACE_SETFPREGS 15
#define PTRACE_GETFPXREGS 18
#define PTRACE_SETFPXREGS 19

#define PTRACE_OLDSETOPTIONS 21

#define PTRACE_GET_THREAD_AREA 25
#define PTRACE_SET_THREAD_AREA 26

#ifdef __x86_64__
#define PTRACE_ARCH_PRCTL 30
#else
#define PTRACE_SYSEMU 31
#define PTRACE_SYSEMU_SINGLESTEP 32
#endif

#endif
