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
#ifndef _LINUX_RESOURCE_H
#define _LINUX_RESOURCE_H

#include <linux/time.h>

struct task_struct;

#define RUSAGE_SELF 0
#define RUSAGE_CHILDREN (-1)
#define RUSAGE_BOTH (-2)  

struct rusage {
 struct timeval ru_utime;
 struct timeval ru_stime;
 long ru_maxrss;
 long int __unused1;
 long ru_ixrss;
 long int __unused2;
 long ru_idrss;
 long int __unused3;
 long ru_isrss;
 long int __unused4;
 long ru_minflt;
 long int __unused5;
 long ru_majflt;
 long int __unused6;
 long ru_nswap;
 long int __unused7;
 long ru_inblock;
 long int __unused8;
 long ru_oublock;
 long int __unused9;
 long ru_msgsnd;
 long int __unused10;
 long ru_msgrcv;
 long int __unused11;
 long ru_nsignals;
 long int __unused12;
 long ru_nvcsw;
 long int __unused13;
 long ru_nivcsw;
 long int __unused14;
};

struct rlimit {
 unsigned long long rlim_cur;
 unsigned long long rlim_max;
};

#define PRIO_MIN (-20)
#define PRIO_MAX 20

#define PRIO_PROCESS 0
#define PRIO_PGRP 1
#define PRIO_USER 2

#define _STK_LIM (8*1024*1024)

#define MLOCK_LIMIT (8 * PAGE_SIZE)

#include <asm/resource.h>

#endif
