include config.mk

BIONIC_DIR=$(PWD)/../bionic
BIONIC_LIBC_DIR=$(BIONIC_DIR)/libc
BIONIC_LIBM_DIR=$(BIONIC_DIR)/libm
BIONIC_LIBDL_DIR=$(BIONIC_DIR)/libdl
BIONIC_LINKER_DIR=$(BIONIC_DIR)/linker
BIONIC_LIBSTDCXX_DIR=$(BIONIC_DIR)/libstdc++

CORE_DIR=$(PWD)/../core
CORE_INCLUDE_DIR=$(CORE_DIR)/include

ARCH?=x86

INCLUDES=\
	-I$(BIONIC_LIBC_DIR)/arch-$(ARCH)/include \
	-I$(BIONIC_LIBC_DIR)/include \
	-I$(BIONIC_LIBC_DIR)/kernel/arch-$(ARCH) \
	-I$(BIONIC_LIBC_DIR)/private \
	-I$(BIONIC_LIBC_DIR)/kernel \
	-I$(BIONIC_LIBC_DIR)/kernel/common \
	-I$(BIONIC_LIBM_DIR)/include \

ifeq ($(ARCH),x86)
INCLUDES+=-I$(BIONIC_LIBM_DIR)/include/i387
else
INCLUDES+=-I$(BIONIC_LIBM_DIR)/include/amd64
endif

CPP_FLAGS=-Ulinux -D__ANDROID__ -DANDROID -DUSE_SSSE3 -DUSE_SSE2 -DPIC
CPP_FLAGS+=-DSHARED
CPP_FLAGS+=-DANDROID_SMP=1
ifeq ($(ARCH),x86)
CFLAGS=-m32 -march=atom -mbionic
else
CFLAGS=-mx32
endif
CFLAGS+=-fPIC -fno-exceptions $(INCLUDES) $(CPP_FLAGS)
LIBGCC=$(shell $(CC) $(CFLAGS) -print-libgcc-file-name)
LIBSUPCXX?=$(shell $(CC) $(CFLAGS) -print-file-name=libsupc++.a)

CFLAGS+=-O2 -g

LDFLAGS=-Wl,-z,nocombreloc
SHLIB_LDFLAGS=-Wl,-Bsymbolic -Wl,-O1 -Wl,--no-undefined
SHLIB_LDFLAGS+=-Wl,--warn-shared-textrel,--fatal-warnings
DYNAMIC_LDFLAGS=-Wl,-z,nocopyreloc 

OBJCOPY=objcopy

BUILD_DIR=$(ARCH)
OBJ_DIR=$(BUILD_DIR)/obj
LIB_DIR=$(BUILD_DIR)/lib
EXE_DIR=$(BUILD_DIR)/exe

crt_OBJS=crtbegin_dynamic.o crtbegin_so.o crtbegin_static.o \
 	 crtend_android.o crtend_so.o
crt_OBJS:=$(addprefix $(LIB_DIR)/, $(crt_OBJS))
OBJS+=$(crt_OBJS)
VPATH+=$(BIONIC_LIBC_DIR)/arch-$(ARCH)/bionic

libdl.so_OBJS=libdl.os
libdl.so_OBJS:=$(addprefix $(OBJ_DIR)/, $(libdl.so_OBJS))
OBJS+=$(libdl.so_OBJS)
libdl.so_LIB=libdl.so
libdl.so_LIB:=$(addprefix $(LIB_DIR)/, $(libdl.so_LIB))
SHARED_LIBS+=$(libdl.so_LIB)
VPATH+=$(BIONIC_LIBDL_DIR)

libdl.so_LDFLAGS=-Wl,-Bsymbolic -Wl,-O1
libdl.so_LDFLAGS+=-Wl,--warn-shared-textrel,--fatal-warnings

include $(BIONIC_LIBC_DIR)/arch-$(ARCH)/syscalls.mk

# The following files are common, but must be compiled
# with different C flags when building a static C library.
#
# The reason for this is the implementation of __get_tls()
# that will differ between the shared and static versions
# of the library.
#
# See comments in private/bionic_tls.h for more details.
#
# NOTE: bionic/pthread.c is added later to this list
#       because it needs special handling on ARM, see
#       below.
#
libc_static_common_src_files := \
        unistd/sysconf.c \
        bionic/__errno.c \

# Define the common source files for all the libc instances
# =========================================================
libc_common_src_files := \
	$(syscall_src) \
	unistd/abort.c \
	unistd/alarm.c \
	unistd/brk.c \
	unistd/creat.c \
	unistd/daemon.c \
	unistd/eventfd.c \
	unistd/exec.c \
	unistd/fcntl.c \
	unistd/fnmatch.c \
	unistd/fstatfs.c \
	unistd/ftime.c \
	unistd/ftok.c \
	unistd/getcwd.c \
	unistd/getdtablesize.c \
	unistd/gethostname.c \
	unistd/getopt_long.c \
	unistd/getpgrp.c \
	unistd/getpriority.c \
	unistd/getpt.c \
	unistd/initgroups.c \
	unistd/isatty.c \
	unistd/issetugid.c \
	unistd/killpg.c \
	unistd/nice.c \
	unistd/open.c \
	unistd/openat.c \
	unistd/opendir.c \
	unistd/pathconf.c \
	unistd/perror.c \
	unistd/popen.c \
	unistd/pread.c \
	unistd/pselect.c \
	unistd/ptsname.c \
	unistd/ptsname_r.c \
	unistd/pwrite.c \
	unistd/raise.c \
	unistd/reboot.c \
	unistd/recv.c \
	unistd/sbrk.c \
	unistd/send.c \
	unistd/setegid.c \
	unistd/setuid.c \
	unistd/seteuid.c \
	unistd/setreuid.c \
	unistd/setresuid.c \
	unistd/setpgrp.c \
	unistd/sigblock.c \
	unistd/siginterrupt.c \
	unistd/siglist.c \
	unistd/signal.c \
	unistd/signame.c \
	unistd/sigsetmask.c \
	unistd/sigwait.c \
	unistd/sleep.c \
	unistd/statfs.c \
	unistd/strsignal.c \
	unistd/syslog.c \
	unistd/system.c \
	unistd/tcgetpgrp.c \
	unistd/tcsetpgrp.c \
	unistd/time.c \
	unistd/umount.c \
	unistd/unlockpt.c \
	unistd/usleep.c \
	unistd/wait.c \
	stdio/asprintf.c \
	stdio/clrerr.c \
	stdio/fclose.c \
	stdio/fdopen.c \
	stdio/feof.c \
	stdio/ferror.c \
	stdio/fflush.c \
	stdio/fgetc.c \
	stdio/fgetln.c \
	stdio/fgetpos.c \
	stdio/fgets.c \
	stdio/fileno.c \
	stdio/findfp.c \
	stdio/flags.c \
	stdio/flockfile.c \
	stdio/fopen.c \
	stdio/fprintf.c \
	stdio/fpurge.c \
	stdio/fputc.c \
	stdio/fputs.c \
	stdio/fread.c \
	stdio/freopen.c \
	stdio/fscanf.c \
	stdio/fseek.c \
	stdio/fsetpos.c \
	stdio/ftell.c \
	stdio/funopen.c \
	stdio/fvwrite.c \
	stdio/fwalk.c \
	stdio/fwrite.c \
	stdio/getc.c \
	stdio/getchar.c \
	stdio/gets.c \
	stdio/makebuf.c \
	stdio/mktemp.c \
	stdio/printf.c \
	stdio/putc.c \
	stdio/putchar.c \
	stdio/puts.c \
	stdio/putw.c \
	stdio/refill.c \
	stdio/remove.c \
	stdio/rewind.c \
	stdio/rget.c \
	stdio/scanf.c \
	stdio/setbuf.c \
	stdio/setbuffer.c \
	stdio/setvbuf.c \
	stdio/snprintf.c\
	stdio/sprintf.c \
	stdio/sscanf.c \
	stdio/stdio.c \
	stdio/tempnam.c \
	stdio/tmpfile.c \
	stdio/tmpnam.c \
	stdio/ungetc.c \
	stdio/vasprintf.c \
	stdio/vfprintf.c \
	stdio/vfscanf.c \
	stdio/vprintf.c \
	stdio/vsnprintf.c \
	stdio/vsprintf.c \
	stdio/vscanf.c \
	stdio/vsscanf.c \
	stdio/wbuf.c \
	stdio/wsetup.c \
	stdlib/_rand48.c \
	stdlib/assert.c \
	stdlib/atexit.c \
	stdlib/atoi.c \
	stdlib/atol.c \
	stdlib/atoll.c \
	stdlib/bsearch.c \
	stdlib/ctype_.c \
	stdlib/div.c \
	stdlib/exit.c \
	stdlib/getenv.c \
	stdlib/jrand48.c \
	stdlib/ldiv.c \
	stdlib/lldiv.c \
	stdlib/locale.c \
	stdlib/lrand48.c \
	stdlib/mrand48.c \
	stdlib/nrand48.c \
	stdlib/putenv.c \
	stdlib/qsort.c \
	stdlib/seed48.c \
	stdlib/setenv.c \
	stdlib/setjmperr.c \
	stdlib/srand48.c \
	stdlib/strntoimax.c \
	stdlib/strntoumax.c \
	stdlib/strtod.c \
	stdlib/strtoimax.c \
	stdlib/strtol.c \
	stdlib/strtoll.c \
	stdlib/strtoul.c \
	stdlib/strtoull.c \
	stdlib/strtoumax.c \
	stdlib/tolower_.c \
	stdlib/toupper_.c \
	stdlib/wchar.c \
	string/index.c \
	string/memccpy.c \
	string/memchr.c \
	string/memmem.c \
	string/memrchr.c \
	string/memswap.c \
	string/strcasecmp.c \
	string/strcasestr.c \
	string/strcat.c \
	string/strchr.c \
	string/strcoll.c \
	string/strcspn.c \
	string/strdup.c \
	string/strerror.c \
	string/strerror_r.c \
	string/strlcat.c \
	string/strlcpy.c \
	string/strncat.c \
	string/strncpy.c \
	string/strndup.c \
	string/strnlen.c \
	string/strpbrk.c \
	string/strrchr.c \
	string/strsep.c \
	string/strspn.c \
	string/strstr.c \
	string/strtok.c \
	string/strtotimeval.c \
	string/strxfrm.c \
	wchar/wcpcpy.c \
	wchar/wcpncpy.c \
	wchar/wcscasecmp.c \
	wchar/wcscat.c \
	wchar/wcschr.c \
	wchar/wcscmp.c \
	wchar/wcscoll.c \
	wchar/wcscpy.c \
	wchar/wcscspn.c \
	wchar/wcsdup.c \
	wchar/wcslcat.c \
	wchar/wcslcpy.c \
	wchar/wcslen.c \
	wchar/wcsncasecmp.c \
	wchar/wcsncat.c \
	wchar/wcsncmp.c \
	wchar/wcsncpy.c \
	wchar/wcsnlen.c \
	wchar/wcspbrk.c \
	wchar/wcsrchr.c \
	wchar/wcsspn.c \
	wchar/wcsstr.c \
	wchar/wcstok.c \
	wchar/wcswidth.c \
	wchar/wcsxfrm.c \
	wchar/wmemchr.c \
	wchar/wmemcmp.c \
	wchar/wmemcpy.c \
	wchar/wmemmove.c \
	wchar/wmemset.c \
	inet/bindresvport.c \
	inet/inet_addr.c \
	inet/inet_aton.c \
	inet/inet_ntoa.c \
	inet/inet_ntop.c \
	inet/inet_pton.c \
	inet/ether_aton.c \
	inet/ether_ntoa.c \
	tzcode/asctime.c \
	tzcode/difftime.c \
	tzcode/localtime.c \
	tzcode/strftime.c \
	tzcode/strptime.c \
	bionic/__set_errno.c \
	bionic/cpuacct.c \
	bionic/arc4random.c \
	bionic/basename.c \
	bionic/basename_r.c \
	bionic/clearenv.c \
	bionic/dirname.c \
	bionic/dirname_r.c \
	bionic/drand48.c \
	bionic/erand48.c \
	bionic/err.c \
	bionic/fdprintf.c \
	bionic/fork.c \
	bionic/fts.c \
	bionic/if_nametoindex.c \
	bionic/if_indextoname.c \
	bionic/ioctl.c \
	bionic/ldexp.c \
	bionic/libc_init_common.c \
	bionic/logd_write.c \
	bionic/md5.c \
	bionic/pututline.c \
	bionic/realpath.c \
	bionic/sched_getaffinity.c \
	bionic/sched_getcpu.c \
	bionic/sched_cpualloc.c \
	bionic/sched_cpucount.c \
	bionic/semaphore.c \
	bionic/sha1.c \
	bionic/ssp.c \
	bionic/stubs.c \
	bionic/system_properties.c \
	bionic/time64.c \
	bionic/thread_atexit.c \
	bionic/utime.c \
	bionic/utmp.c \
	netbsd/gethnamaddr.c \
	netbsd/isc/ev_timers.c \
	netbsd/isc/ev_streams.c \
	netbsd/inet/nsap_addr.c \
	netbsd/resolv/__dn_comp.c \
	netbsd/resolv/__res_close.c \
	netbsd/resolv/__res_send.c \
	netbsd/resolv/herror.c \
	netbsd/resolv/res_comp.c \
	netbsd/resolv/res_data.c \
	netbsd/resolv/res_debug.c \
	netbsd/resolv/res_init.c \
	netbsd/resolv/res_mkquery.c \
	netbsd/resolv/res_query.c \
	netbsd/resolv/res_send.c \
	netbsd/resolv/res_state.c \
	netbsd/resolv/res_cache.c \
	netbsd/net/nsdispatch.c \
	netbsd/net/getaddrinfo.c \
	netbsd/net/getnameinfo.c \
	netbsd/net/getservbyname.c \
	netbsd/net/getservent.c \
	netbsd/net/base64.c \
	netbsd/net/getservbyport.c \
	netbsd/nameser/ns_name.c \
	netbsd/nameser/ns_parse.c \
	netbsd/nameser/ns_ttl.c \
	netbsd/nameser/ns_netint.c \
	netbsd/nameser/ns_print.c \
	netbsd/nameser/ns_samedomain.c \
	regex/regcomp.c \
	regex/regerror.c \
	regex/regexec.c \
	regex/regfree.c \

libc_common_src_files += \
	arch-$(ARCH)/bionic/__get_sp.S \
	arch-$(ARCH)/bionic/__get_tls.c \
	arch-$(ARCH)/bionic/__set_tls.c \
	arch-$(ARCH)/bionic/atomics_$(ARCH).S \
	arch-$(ARCH)/bionic/clone.S \
	arch-$(ARCH)/bionic/_exit_with_stack_teardown.S \
	arch-$(ARCH)/bionic/setjmp.S \
	arch-$(ARCH)/bionic/_setjmp.S \
	arch-$(ARCH)/bionic/sigsetjmp.S \
	arch-$(ARCH)/bionic/vfork.S \
	arch-$(ARCH)/bionic/syscall.S \
	string/strcpy.c \
	bionic/pthread-atfork.c \
	bionic/pthread-rwlocks.c \
	bionic/pthread.c \
	bionic/pthread-timers.c \
	bionic/ptrace.c

ifeq (X$(ARCH),x86)
libc_common_src_files+= \
	arch-$(ARCH)/string/bcopy_wrapper.S \
	arch-$(ARCH)/string/memcpy_wrapper.S \
	arch-$(ARCH)/string/memmove_wrapper.S \
	arch-$(ARCH)/string/bzero_wrapper.S \
	arch-$(ARCH)/string/memcmp_wrapper.S \
	arch-$(ARCH)/string/memset_wrapper.S \
	arch-$(ARCH)/string/strcmp_wrapper.S \
	arch-$(ARCH)/string/strncmp_wrapper.S \
	arch-$(ARCH)/string/strlen_wrapper.S
else
libc_common_src_files+= \
	string/bcopy.c \
	string/memcpy.c \
	string/memmove.c \
	string/memcmp.c \
	string/memset.c \
	string/strcmp.c \
	string/strncmp.c \
	string/strlen.c
endif

ifeq ($(ARCH),x86)
libc_common_src_files+= \
	unistd/sigsuspend.c \
	unistd/lseek64.c \
	unistd/mmap.c
else
libc_common_src_files+= \
	arch-$(ARCH)/bionic/__rt_sigreturn.S \
	arch-$(ARCH)/bionic/sigsuspend.c \
	arch-$(ARCH)/bionic/sigaction.c \
	arch-$(ARCH)/bionic/sigprocmask.c \
	arch-$(ARCH)/bionic/lseek.S \
	arch-$(ARCH)/bionic/mmap.S 
endif

# this is needed for static versions of libc
libc_arch_static_src_files := \
	arch-$(ARCH)/bionic/dl_iterate_phdr_static.c

libc_arch_dynamic_src_files :=

VPATH+=$(BIONIC_LIBC_DIR)

# Define some common cflags
# ========================================================
libc_common_cflags := \
		-DWITH_ERRLIST			\
		-DANDROID_CHANGES		\
		-DUSE_LOCKS 			\
		-DREALLOC_ZERO_BYTES_FREES 	\
		-D_LIBC=1 			\
		-DSOFTFLOAT                     \
		-DFLOATING_POINT		\
		-DINET6 \
		-I$(BIONIC_LIBC_DIR)/private \
		-DUSE_DL_PREFIX \
		-DPOSIX_MISTAKE

# these macro definitions are required to implement the
# 'timezone' and 'daylight' global variables, as well as
# properly update the 'tm_gmtoff' field in 'struct tm'.
#
libc_common_cflags += \
    -DTM_GMTOFF=tm_gmtoff \
    -DUSG_COMPAT=1

ifeq ($(strip $(DEBUG_BIONIC_LIBC)),true)
  libc_common_cflags += -DDEBUG
endif

# Define some common includes
# ========================================================
libc_common_c_includes=\
		$(BIONIC_LIBC_DIR)/stdlib  \
		$(BIONIC_LIBC_DIR)/string  \
		$(BIONIC_LIBC_DIR)/stdio \
		$(CORE_INCLUDE_DIR)
libc_common_cflags+= $(addprefix -I, $(libc_common_c_includes))

# ========================================================
# libc.a
# ========================================================
malloc_src_files=\
	bionic/dlmalloc.c \
	bionic/malloc_debug_common.c

libc_nomalloc_src_files := \
	$(libc_common_src_files) \
	$(libc_static_common_src_files) \
	$(libc_arch_static_src_files) \
	bionic/libc_init_static.c
libc_nomalloc.a_OBJS=$(addsuffix .os, $(basename $(libc_nomalloc_src_files)))
libc_nomalloc.a_OBJS:=$(addprefix $(OBJ_DIR)/, $(libc_nomalloc.a_OBJS))
OBJS+=$(libc_nomalloc.a_OBJS)
libc_nomalloc.a_LIB=libc_nomalloc.a
libc_nomalloc.a_LIB:=$(addprefix $(LIB_DIR)/, $(libc_nomalloc.a_LIB))
STATIC_LIBS+=$(libc_nomalloc.a_LIB)

$(libc_nomalloc.a_OBJS): CFLAGS += $(libc_common_cflags)

libc.a_src_files=$(libc_nomalloc_src_files) $(malloc_src_files)
libc.a_OBJS=$(addsuffix .o, $(basename $(libc.a_src_files)))
libc.a_OBJS:=$(addprefix $(OBJ_DIR)/, $(libc.a_OBJS))
OBJS+=$(libc.a_OBJS)
libc.a_LIB=libc.a
libc.a_LIB:=$(addprefix $(LIB_DIR)/, $(libc.a_LIB))
STATIC_LIBS+=$(libc.a_LIB)

$(libc.a_OBJS): CFLAGS += $(libc_common_cflags) -DLIBC_STATIC

STATIC_LIBC=-Wl,--start-group $(libc.a_LIB) $(LIBGCC) -Wl,--end-group

# ========================================================
# libc.so
# ========================================================
libc.so_cflags := $(libc_common_cflags)

libc.so_src_files := \
	$(libc_common_src_files) \
	$(libc_static_common_src_files) \
	$(libc_arch_dynamic_src_files) \
	$(malloc_src_files) \
	bionic/libc_init_dynamic.c
libc.so_OBJS=$(addsuffix .os, $(basename $(libc.so_src_files)))
libc.so_OBJS:=$(addprefix $(OBJ_DIR)/, $(libc.so_OBJS))
OBJS+=$(libc.so_OBJS)
libc.so_LIB=libc.so
libc.so_LIB:=$(addprefix $(LIB_DIR)/, $(libc.so_LIB))
SHARED_LIBS+=$(libc.so_LIB)
libc.so_DEPS=$(libdl.so_LIB) $(LIBGCC)

$(libc.so_OBJS): CFLAGS += $(libc_common_cflags)

DYNAMIC_LIBC=$(libc.so_LIB) $(libdl.so_LIB) $(LIBGCC)

libm_common_src_files:= \
	isinf.c  \
	fpclassify.c \
	sincos.c \
	bsdsrc/b_exp.c \
	bsdsrc/b_log.c \
	bsdsrc/b_tgamma.c \
	src/e_acos.c \
	src/e_acosf.c \
	src/e_acosh.c \
	src/e_acoshf.c \
	src/e_asin.c \
	src/e_asinf.c \
	src/e_atan2.c \
	src/e_atan2f.c \
	src/e_atanh.c \
	src/e_atanhf.c \
	src/e_cosh.c \
	src/e_coshf.c \
	src/e_exp.c \
	src/e_expf.c \
	src/e_fmod.c \
	src/e_fmodf.c \
	src/e_gamma.c \
	src/e_gamma_r.c \
	src/e_gammaf.c \
	src/e_gammaf_r.c \
	src/e_hypot.c \
	src/e_hypotf.c \
	src/e_j0.c \
	src/e_j0f.c \
	src/e_j1.c \
	src/e_j1f.c \
	src/e_jn.c \
	src/e_jnf.c \
	src/e_lgamma.c \
	src/e_lgamma_r.c \
	src/e_lgammaf.c \
	src/e_lgammaf_r.c \
	src/e_log.c \
	src/e_log10.c \
	src/e_log10f.c \
	src/e_logf.c \
	src/e_pow.c \
	src/e_powf.c \
	src/e_rem_pio2.c \
	src/e_rem_pio2f.c \
	src/e_remainder.c \
	src/e_remainderf.c \
	src/e_scalb.c \
	src/e_scalbf.c \
	src/e_sinh.c \
	src/e_sinhf.c \
	src/e_sqrt.c \
	src/e_sqrtf.c \
	src/k_cos.c \
	src/k_cosf.c \
	src/k_rem_pio2.c \
	src/k_sin.c \
	src/k_sinf.c \
	src/k_tan.c \
	src/k_tanf.c \
	src/s_asinh.c \
	src/s_asinhf.c \
	src/s_atan.c \
	src/s_atanf.c \
	src/s_cbrt.c \
	src/s_cbrtf.c \
	src/s_ceil.c \
	src/s_ceilf.c \
	src/s_ceill.c \
	src/s_copysign.c \
	src/s_copysignf.c \
	src/s_cos.c \
	src/s_cosf.c \
	src/s_erf.c \
	src/s_erff.c \
	src/s_exp2.c \
	src/s_exp2f.c \
	src/s_expm1.c \
	src/s_expm1f.c \
	src/s_fabsf.c \
	src/s_fdim.c \
	src/s_finite.c \
	src/s_finitef.c \
	src/s_floor.c \
	src/s_floorf.c \
	src/s_floorl.c \
	src/s_fma.c \
	src/s_fmaf.c \
	src/s_fmax.c \
	src/s_fmaxf.c \
	src/s_fmaxl.c \
	src/s_fmin.c \
	src/s_fminf.c \
	src/s_fminl.c \
	src/s_frexpf.c \
	src/s_ilogb.c \
	src/s_ilogbf.c \
	src/s_ilogbl.c \
	src/s_isfinite.c \
	src/s_isnormal.c \
	src/s_llrint.c \
	src/s_llrintf.c \
	src/s_llround.c \
	src/s_llroundf.c \
	src/s_llroundl.c \
	src/s_log1p.c \
	src/s_log1pf.c \
	src/s_logb.c \
	src/s_logbf.c \
	src/s_lrint.c \
	src/s_lrintf.c \
	src/s_lround.c \
	src/s_lroundf.c \
	src/s_lroundl.c \
	src/s_modff.c \
	src/s_nearbyint.c \
	src/s_nextafter.c \
	src/s_nextafterf.c \
	src/s_nexttowardf.c \
	src/s_remquo.c \
	src/s_remquof.c \
	src/s_rint.c \
	src/s_rintf.c \
	src/s_round.c \
	src/s_roundf.c \
	src/s_roundl.c \
	src/s_signbit.c \
	src/s_signgam.c \
	src/s_significand.c \
	src/s_significandf.c \
	src/s_sin.c \
	src/s_sinf.c \
	src/s_tan.c \
	src/s_tanf.c \
	src/s_tanh.c \
	src/s_tanhf.c \
	src/s_trunc.c \
	src/s_truncf.c \
	src/s_truncl.c \
	src/w_drem.c \
	src/w_dremf.c \
	src/s_copysignl.c \
	src/s_fabsl.c \
	src/s_fabs.c \
	src/s_frexp.c \
	src/s_isnan.c \
	src/s_modf.c

ifeq ($(ARCH),x86)
libm_common_src_files += \
	i387/fenv.c \
	i387/s_scalbnl.S \
	i387/s_scalbn.S \
	i387/s_scalbnf.S
else
libm_common_src_files += \
	amd64/fenv.c \
	amd64/s_scalbnl.S \
	amd64/s_scalbn.S \
	amd64/s_scalbnf.S
endif

VPATH+=$(BIONIC_LIBM_DIR)

ifeq ($(ARCH),x86)
libm_common_includes = $(BIONIC_LIBM_DIR)/i386 $(BIONIC_LIBM_DIR)/i387
else
libm_common_includes = $(BIONIC_LIBM_DIR)/amd64
endif
libm_common_cflags+= $(addprefix -I, $(libm_common_includes))

# libm.a
# ========================================================

libm.a_OBJS=$(addsuffix .o, $(basename $(libm_common_src_files)))
libm.a_OBJS:=$(addprefix $(OBJ_DIR)/, $(libm.a_OBJS))
OBJS+=$(libm.a_OBJS)
libm.a_LIB=libm.a
libm.a_LIB:=$(addprefix $(LIB_DIR)/, $(libm.a_LIB))
STATIC_LIBS+=$(libm.a_LIB)

$(libm.a_OBJS): CFLAGS += $(libm_common_cflags)

# libm.so
# ========================================================

libm.so_OBJS=$(libm.a_OBJS)
libm.so_LIB=libm.so
libm.so_LIB:=$(addprefix $(LIB_DIR)/, $(libm.so_LIB))
SHARED_LIBS+=$(libm.so_LIB)
libm.so_DEPS=$(libc.so_LIB)

libstdc++_common_src_files := \
	src/one_time_construction.cpp \
	src/new.cpp \
	src/pure_virtual.cpp \
	src/typeinfo.cpp

VPATH+=$(BIONIC_LIBSTDCXX_DIR)

libstdc++_common_cflags := -I$(BIONIC_LIBC_DIR)/private
libstdc++_common_cflags += -I$(BIONIC_LIBSTDCXX_DIR)/include
libstdc++_common_cflags += -DANDROID_SMP=1

# libstdc++.a
# ========================================================

libstdc++.a_OBJS=$(addsuffix .o, $(basename $(libstdc++_common_src_files)))
libstdc++.a_OBJS:=$(addprefix $(OBJ_DIR)/, $(libstdc++.a_OBJS))
OBJS+=$(libstdc++.a_OBJS)
libstdc++.a_LIB=libstdc++.a
libstdc++.a_LIB:=$(addprefix $(LIB_DIR)/, $(libstdc++.a_LIB))
STATIC_LIBS+=$(libstdc++.a_LIB)

$(libstdc++.a_OBJS): CFLAGS += $(libstdc++_common_cflags)

# libstdc++.so
# ========================================================

libstdc++.so_OBJS=$(libstdc++.a_OBJS)
libstdc++.so_LIB=libstdc++.so
libstdc++.so_LIB:=$(addprefix $(LIB_DIR)/, $(libstdc++.so_LIB))
SHARED_LIBS+=$(libstdc++.so_LIB)
libstdc++.so_DEPS=$(libc.so_LIB)
libstdc++.so_LIBS=$(LIBGCC) $(LIBSUPCXX) $(LIBGCC)

DYNAMIC_LIBSTDCXX=$(libstdc++.so_LIB) \
	$(LIBGCC) $(LIBSUPCXX) $(LIBGCC) \
	$(libc.so_LIB)

STATIC_LIBSTDCXX=$(libstdc++.a_LIB) \
	$(LIBGCC) $(LIBSUPCXX) $(LIBGCC) \
	$(libc.a_LIB) $(LIBGCC)

LINKER_SRC_FILES:= \
	arch/$(ARCH)/begin.S \
	linker.c \
	linker_environ.c \
	linker_format.c \
	rt.c \
	dlfcn.c \
	debugger.c \
	ba.c

# This is aligned to 4K page boundary so that both GNU ld and gold work.  Gold
# actually produces a correct binary with starting address 0xB0000100 but the
# extra objcopy step to rename symbols causes the resulting binary to be misaligned
# and unloadable.  Increasing the alignment adds an extra 3840 bytes in padding
# but switching to gold saves about 1M of space.
LINKER_TEXT_BASE := 0xB0001000

# The maximum size set aside for the linker, from
# LINKER_TEXT_BASE rounded down to a megabyte.
LINKER_AREA_SIZE := 0x01000000

ld.so_LDFLAGS := -Wl,-Ttext,$(LINKER_TEXT_BASE)

LINKER_CFLAGS += -DPRELINK
LINKER_CFLAGS += -DLINKER_TEXT_BASE=$(LINKER_TEXT_BASE)
LINKER_CFLAGS += -DLINKER_AREA_SIZE=$(LINKER_AREA_SIZE)

# Set LINKER_DEBUG to either 1 or 0
#
LINKER_CFLAGS += -DLINKER_DEBUG=0

# we need to access the Bionic private header <bionic_tls.h>
# in the linker; duplicate the HAVE_ARM_TLS_REGISTER definition
# from the libc build
LINKER_CFLAGS += -I$(BIONIC_LINKER_DIR)
LINKER_CFLAGS += -I$(CORE_INCLUDE_DIR)

ifeq ($(ARCH),x86)
LINKER_CFLAGS += -DANDROID_X86_LINKER
else
LINKER_CFLAGS += -DANDROID_X32_LINKER
endif

ld.so_OBJS=$(addsuffix .o, $(basename $(LINKER_SRC_FILES)))
ld.so_OBJS:=$(addprefix $(OBJ_DIR)/, $(ld.so_OBJS))
OBJS+=$(ld.so_OBJS)
ld.so_LIB=ld.so
ld.so_LIB:=$(addprefix $(LIB_DIR)/, $(ld.so_LIB))
ld.so_DEPS=\
	-Wl,--start-group \
	$(libc_nomalloc.a_LIB) \
	$(LIBGCC) \
	-Wl,--end-group
VPATH+=$(BIONIC_LINKER_DIR)

$(ld.so_OBJS): CFLAGS += $(LINKER_CFLAGS)

LD.SO=$(PWD)/$(ld.so_LIB)

init-mixed_OBJS=init-mixed.o
init-mixed_OBJS:=$(addprefix $(OBJ_DIR)/, $(init-mixed_OBJS))
OBJS+=$(init-mixed_OBJS)
init-mixed.static_OBJS=$(init-mixed_OBJS)
init-mixed.static_EXE=init-mixed.static
init-mixed.static_EXE:=$(addprefix $(EXE_DIR)/, $(init-mixed.static_EXE))
EXES+=$(init-mixed.static_EXE)
init-mixed.dynamic_OBJS=$(init-mixed_OBJS)
init-mixed.dynamic_EXE=init-mixed.dynamic
init-mixed.dynamic_EXE:=$(addprefix $(EXE_DIR)/, $(init-mixed.dynamic_EXE))
EXES+=$(init-mixed.dynamic_EXE)

hello_OBJS=hello.o
hello_OBJS:=$(addprefix $(OBJ_DIR)/, $(hello_OBJS))
OBJS+=$(hello_OBJS)
hello.static_OBJS=$(hello_OBJS)
hello.static_EXE=hello.static
hello.static_EXE:=$(addprefix $(EXE_DIR)/, $(hello.static_EXE))
EXES+=$(hello.static_EXE)
hello.dynamic_OBJS=$(hello_OBJS)
hello.dynamic_EXE=hello.dynamic
hello.dynamic_EXE:=$(addprefix $(EXE_DIR)/, $(hello.dynamic_EXE))
EXES+=$(hello.dynamic_EXE)

test_basic_exceptions_OBJS=test_basic_exceptions.o
test_basic_exceptions_OBJS:=$(addprefix $(OBJ_DIR)/, $(test_basic_exceptions_OBJS))
OBJS+=$(test_basic_exceptions_OBJS)
test_basic_exceptions.static_OBJS=$(test_basic_exceptions_OBJS)
test_basic_exceptions.static_EXE=test_basic_exceptions.static
test_basic_exceptions.static_EXE:=$(addprefix $(EXE_DIR)/, $(test_basic_exceptions.static_EXE))
EXES+=$(test_basic_exceptions.static_EXE)
test_basic_exceptions.dynamic_OBJS=$(test_basic_exceptions_OBJS)
test_basic_exceptions.dynamic_EXE=test_basic_exceptions.dynamic
test_basic_exceptions.dynamic_EXE:=$(addprefix $(EXE_DIR)/, $(test_basic_exceptions.dynamic_EXE))
EXES+=$(test_basic_exceptions.dynamic_EXE)
$(test_basic_exceptions_OBJS): CFLAGS += -fexceptions

$(test_basic_exceptions_OBJS): CFLAGS += $(libstdc++_common_cflags)

libexception-foo.so_OBJS=exception-foo.o
libexception-foo.so_OBJS:=$(addprefix $(OBJ_DIR)/, $(libexception-foo.so_OBJS))
OBJS+=$(libexception-foo.so_OBJS)
libexception-foo.so_LIB=libexception-foo.so
libexception-foo.so_LIB:=$(addprefix $(LIB_DIR)/, $(libexception-foo.so_LIB))
libexception-foo.so_LIBS = $(DYNAMIC_LIBSTDCXX)
$(libexception-foo.so_OBJS): CFLAGS += -fexceptions

exception-main_OBJS=exception-main.o
exception-main_OBJS:=$(addprefix $(OBJ_DIR)/, $(exception-main_OBJS))
OBJS+=$(exception-main_OBJS)
exception-main.dynamic_OBJS=$(exception-main_OBJS)
exception-main.dynamic_EXE=exception-main.dynamic
exception-main.dynamic_EXE:=$(addprefix $(EXE_DIR)/, $(exception-main.dynamic_EXE))
exception-main.dynamic_DEPS= $(libexception-foo.so_LIB)
EXES+=$(exception-main.dynamic_EXE)
$(exception-main_OBJS): CFLAGS += -fexceptions

$(exception-main_OBJS): CFLAGS += $(libstdc++_common_cflags)

pr47383_OBJS=pr47383.o
pr47383_OBJS:=$(addprefix $(OBJ_DIR)/, $(pr47383_OBJS))
OBJS+=$(pr47383_OBJS)
pr47383.static_OBJS=$(pr47383_OBJS)
pr47383.static_EXE=pr47383.static
pr47383.static_EXE:=$(addprefix $(EXE_DIR)/, $(pr47383.static_EXE))
EXES+=$(pr47383.static_EXE)
pr47383.dynamic_OBJS=$(pr47383_OBJS)
pr47383.dynamic_EXE=pr47383.dynamic
pr47383.dynamic_EXE:=$(addprefix $(EXE_DIR)/, $(pr47383.dynamic_EXE))
EXES+=$(pr47383.dynamic_EXE)

VPATH+=test

#$(init-mixed_OBJS): CFLAGS+=-O0 -g

all: $(OBJS) $(SHARED_LIBS) $(STATIC_LIBS) $(ld.so_LIB) $(EXES) .gdbinit
	export LD_LIBRARY_PATH=$(LIB_DIR); \
	for f in $(EXES); do \
	  ./$$f; \
	done

define build-dynamic-executable
$(CC) $(CFLAGS) -o $@ -nostdlib $(DYNAMIC_LDFLAGS) $(LDFLAGS) \
	-Wl,-dynamic-linker $(LD.SO) \
	$(LIB_DIR)/crtbegin_dynamic.o $($(@F)_OBJS) $($(@F)_DEPS) \
	$(DYNAMIC_LIBC) $(LIB_DIR)/crtend_android.o
endef

define build-static-executable
$(CC) $(CFLAGS) -o $@ -nostdlib -Wl,-Bstatic $(LDFLAGS) \
	$(LIB_DIR)/crtbegin_static.o $($(@F)_OBJS) $($(@F)_DEPS) \
	$(STATIC_LIBC) $(LIB_DIR)/crtend_android.o
endef

define build-dynamic-c++-executable
$(CC) $(CFLAGS) -o $@ -nostdlib -Wl,-z,nocopyreloc $(LDFLAGS) \
	-Wl,-dynamic-linker $(LD.SO) \
	$(LIB_DIR)/crtbegin_dynamic.o $($(@F)_OBJS) $($(@F)_DEPS) \
	$(DYNAMIC_LIBSTDCXX) $(LIB_DIR)/crtend_android.o
endef

define build-static-c++-executable
$(CC) $(CFLAGS) -o $@ -nostdlib -Wl,-Bstatic $(LDFLAGS) \
	$(LIB_DIR)/crtbegin_static.o $($(@F)_OBJS) $($(@F)_DEPS) \
	$(STATIC_LIBSTDCXX) $(LIB_DIR)/crtend_android.o
endef

define build-shlib
$(CC) $(CFLAGS) -o $@ -shared -nostdlib -Wl,-soname=$(@F) \
	$(SHLIB_LDFLAGS) $(LDFLAGS) \
	$(LIB_DIR)/crtbegin_so.o $($(@F)_OBJS) \
	$($(@F)_DEPS) $($(@F)_LIBS) $(LIB_DIR)/crtend_so.o
endef

define build-shlib-ldflags
$(CC) $(CFLAGS) -o $@ -shared -nostdlib -Wl,-soname=$(@F) \
	$($(@F)_LDFLAGS) \
	$(LIB_DIR)/crtbegin_so.o $($(@F)_OBJS) \
	$($(@F)_DEPS) $($(@F)_LIBS) $(LIB_DIR)/crtend_so.o
endef

.SUFFIXES: .S .c .o .so .os .cpp .cc

.S.o:
	-mkdir -p $(@D)
	$(CC) $(CFLAGS) $< -c -o $@

.c.o:
	-mkdir -p $(@D)
	$(CC) $(CFLAGS) $< -c -o $@

.cpp.o:
	-mkdir -p $(@D)
	$(CC) $(CFLAGS) $< -c -o $@

.cc.o:
	-mkdir -p $(@D)
	$(CC) $(CFLAGS) $< -c -o $@

$(OBJ_DIR)/%.o: %.S
	-mkdir -p $(@D)
	$(CC) $(CFLAGS) $< -c -o $@

$(OBJ_DIR)/%.o: %.c
	-mkdir -p $(@D)
	$(CC) $(CFLAGS) $< -c -o $@

$(OBJ_DIR)/%.o: %.cpp
	-mkdir -p $(@D)
	$(CC) $(CFLAGS) $< -c -o $@

$(OBJ_DIR)/%.o: %.cc
	-mkdir -p $(@D)
	$(CC) $(CFLAGS) $< -c -o $@

$(LIB_DIR)/%.o: %.S
	-mkdir -p $(@D)
	$(CC) $(CFLAGS) -c -o $@ $<

$(LIB_DIR)/crtend_android.o: crtend.S
	-mkdir -p $(@D)
	$(CC) $(CFLAGS) $< -c -o $@

.S.os:
	-mkdir -p $(@D)
	$(CC) $(CFLAGS) $< -c -o $@

.c.os:
	-mkdir -p $(@D)
	$(CC) $(CFLAGS) $< -c -o $@

.cpp.os:
	-mkdir -p $(@D)
	$(CC) $(CFLAGS) $< -c -o $@

.cc.os:
	-mkdir -p $(@D)
	$(CC) $(CFLAGS) $< -c -o $@

$(OBJ_DIR)/%.os: %.S
	-mkdir -p $(@D)
	$(CC) $(CFLAGS) $< -c -o $@

$(OBJ_DIR)/%.os: %.c
	-mkdir -p $(@D)
	$(CC) $(CFLAGS) $< -c -o $@

$(OBJ_DIR)/%.os: %.cpp
	-mkdir -p $(@D)
	$(CC) $(CFLAGS) $< -c -o $@

$(OBJ_DIR)/%.os: %.cc
	-mkdir -p $(@D)
	$(CC) $(CFLAGS) $< -c -o $@

$(LIB_DIR)/%.os: %.S
	-mkdir -p $(@D)
	$(CC) $(CFLAGS) $< -c -o $@

$(LIB_DIR)/%.so: $(OBJS)
	-mkdir -p $(@D)
	$(build-shlib)

$(LIB_DIR)/%.a: $(OBJS)
	-mkdir -p $(@D)
	$(AR) rcs $@ $($(@F)_OBJS)

$(libc.so_LIB): $(libdl.so_LIB)

$(libm.so_LIB): $(libc.so_LIB)

$(libstdc++.so_LIB): $(libc.so_LIB)

$(libexception-foo.so_LIB): $(libc.so_LIB) $(libstdc++.so_LIB)

$(LIB_DIR)/ld.so: $(OBJS) $(SHARED_LIBS) $(STATIC_LIBS)
	$(CC) $(CFLAGS) $($(@F)_LDFLAGS) -o $@ -nostdlib -Wl,-Bstatic \
		 $($(@F)_OBJS) $($(@F)_DEPS) $(LIB_DIR)/crtend_android.o
	$(OBJCOPY) --prefix-symbols=__dl_ $@

$(LIB_DIR)/libdl.so: $(OBJS)
	-mkdir -p $(@D)
	$(build-shlib-ldflags)

$(EXE_DIR)/%.static: $(OBJS) $(STATIC_LIBS)
	-mkdir -p $(@D)
	$(build-static-executable)

$(EXE_DIR)/%.dynamic: $(OBJS) $(SHARED_LIBS) $(STATIC_LIBS) $(ld.so_LIB)
	-mkdir -p $(@D)
	$(build-dynamic-executable)

$(EXE_DIR)/test_basic_exceptions.static: $(OBJS) $(STATIC_LIBS)
	-mkdir -p $(@D)
	$(build-static-c++-executable)

$(EXE_DIR)/test_basic_exceptions.dynamic: $(OBJS) $(SHARED_LIBS) $(STATIC_LIBS) $(ld.so_LIB)
	-mkdir -p $(@D)
	$(build-dynamic-c++-executable)

$(EXE_DIR)/exception-main.dynamic: $(OBJS) $(SHARED_LIBS) $(STATIC_LIBS) $(ld.so_LIB) $(libexception-foo.so_LIB)
	-mkdir -p $(@D)
	$(build-dynamic-c++-executable)

.gdbinit: gdbinit
	sed -e "s/@ARCH@/$(ARCH)/" $< >$@

clean:
	rm -rf $(BUILD_DIR) .gdbinit
