# auto-generated by gensyscalls.py, do not touch
syscall_src := 
syscall_src += arch-x32/syscalls/_exit.S
syscall_src += arch-x32/syscalls/_exit_thread.S
syscall_src += arch-x32/syscalls/__fork.S
syscall_src += arch-x32/syscalls/waitid.S
syscall_src += arch-x32/syscalls/__sys_clone.S
syscall_src += arch-x32/syscalls/execve.S
syscall_src += arch-x32/syscalls/__setuid.S
syscall_src += arch-x32/syscalls/getuid.S
syscall_src += arch-x32/syscalls/getgid.S
syscall_src += arch-x32/syscalls/geteuid.S
syscall_src += arch-x32/syscalls/getegid.S
syscall_src += arch-x32/syscalls/getresuid.S
syscall_src += arch-x32/syscalls/getresgid.S
syscall_src += arch-x32/syscalls/gettid.S
syscall_src += arch-x32/syscalls/getgroups.S
syscall_src += arch-x32/syscalls/getpgid.S
syscall_src += arch-x32/syscalls/getppid.S
syscall_src += arch-x32/syscalls/setsid.S
syscall_src += arch-x32/syscalls/setgid.S
syscall_src += arch-x32/syscalls/__setreuid.S
syscall_src += arch-x32/syscalls/__setresuid.S
syscall_src += arch-x32/syscalls/setresgid.S
syscall_src += arch-x32/syscalls/__brk.S
syscall_src += arch-x32/syscalls/kill.S
syscall_src += arch-x32/syscalls/tkill.S
syscall_src += arch-x32/syscalls/__ptrace.S
syscall_src += arch-x32/syscalls/__set_thread_area.S
syscall_src += arch-x32/syscalls/__getpriority.S
syscall_src += arch-x32/syscalls/setpriority.S
syscall_src += arch-x32/syscalls/setrlimit.S
syscall_src += arch-x32/syscalls/getrlimit.S
syscall_src += arch-x32/syscalls/getrusage.S
syscall_src += arch-x32/syscalls/setgroups.S
syscall_src += arch-x32/syscalls/setpgid.S
syscall_src += arch-x32/syscalls/setregid.S
syscall_src += arch-x32/syscalls/chroot.S
syscall_src += arch-x32/syscalls/prctl.S
syscall_src += arch-x32/syscalls/capget.S
syscall_src += arch-x32/syscalls/capset.S
syscall_src += arch-x32/syscalls/sigaltstack.S
syscall_src += arch-x32/syscalls/acct.S
syscall_src += arch-x32/syscalls/read.S
syscall_src += arch-x32/syscalls/write.S
syscall_src += arch-x32/syscalls/__pread64.S
syscall_src += arch-x32/syscalls/__pwrite64.S
syscall_src += arch-x32/syscalls/__open.S
syscall_src += arch-x32/syscalls/__openat.S
syscall_src += arch-x32/syscalls/close.S
syscall_src += arch-x32/syscalls/getpid.S
syscall_src += arch-x32/syscalls/munmap.S
syscall_src += arch-x32/syscalls/mremap.S
syscall_src += arch-x32/syscalls/msync.S
syscall_src += arch-x32/syscalls/mprotect.S
syscall_src += arch-x32/syscalls/madvise.S
syscall_src += arch-x32/syscalls/mlock.S
syscall_src += arch-x32/syscalls/munlock.S
syscall_src += arch-x32/syscalls/mincore.S
syscall_src += arch-x32/syscalls/__ioctl.S
syscall_src += arch-x32/syscalls/readv.S
syscall_src += arch-x32/syscalls/writev.S
syscall_src += arch-x32/syscalls/__fcntl.S
syscall_src += arch-x32/syscalls/flock.S
syscall_src += arch-x32/syscalls/fchmod.S
syscall_src += arch-x32/syscalls/dup.S
syscall_src += arch-x32/syscalls/pipe.S
syscall_src += arch-x32/syscalls/dup2.S
syscall_src += arch-x32/syscalls/select.S
syscall_src += arch-x32/syscalls/ftruncate.S
syscall_src += arch-x32/syscalls/getdents.S
syscall_src += arch-x32/syscalls/fsync.S
syscall_src += arch-x32/syscalls/fchown.S
syscall_src += arch-x32/syscalls/sync.S
syscall_src += arch-x32/syscalls/__fcntl64.S
syscall_src += arch-x32/syscalls/fstatfs.S
syscall_src += arch-x32/syscalls/sendfile.S
syscall_src += arch-x32/syscalls/fstatat.S
syscall_src += arch-x32/syscalls/mkdirat.S
syscall_src += arch-x32/syscalls/fchownat.S
syscall_src += arch-x32/syscalls/fchmodat.S
syscall_src += arch-x32/syscalls/renameat.S
syscall_src += arch-x32/syscalls/link.S
syscall_src += arch-x32/syscalls/unlink.S
syscall_src += arch-x32/syscalls/unlinkat.S
syscall_src += arch-x32/syscalls/chdir.S
syscall_src += arch-x32/syscalls/mknod.S
syscall_src += arch-x32/syscalls/chmod.S
syscall_src += arch-x32/syscalls/chown.S
syscall_src += arch-x32/syscalls/lchown.S
syscall_src += arch-x32/syscalls/mount.S
syscall_src += arch-x32/syscalls/umount2.S
syscall_src += arch-x32/syscalls/fstat.S
syscall_src += arch-x32/syscalls/stat.S
syscall_src += arch-x32/syscalls/lstat.S
syscall_src += arch-x32/syscalls/mkdir.S
syscall_src += arch-x32/syscalls/readlink.S
syscall_src += arch-x32/syscalls/rmdir.S
syscall_src += arch-x32/syscalls/rename.S
syscall_src += arch-x32/syscalls/__getcwd.S
syscall_src += arch-x32/syscalls/access.S
syscall_src += arch-x32/syscalls/symlink.S
syscall_src += arch-x32/syscalls/fchdir.S
syscall_src += arch-x32/syscalls/truncate.S
syscall_src += arch-x32/syscalls/__statfs64.S
syscall_src += arch-x32/syscalls/pause.S
syscall_src += arch-x32/syscalls/gettimeofday.S
syscall_src += arch-x32/syscalls/settimeofday.S
syscall_src += arch-x32/syscalls/times.S
syscall_src += arch-x32/syscalls/nanosleep.S
syscall_src += arch-x32/syscalls/clock_gettime.S
syscall_src += arch-x32/syscalls/clock_settime.S
syscall_src += arch-x32/syscalls/clock_getres.S
syscall_src += arch-x32/syscalls/clock_nanosleep.S
syscall_src += arch-x32/syscalls/getitimer.S
syscall_src += arch-x32/syscalls/setitimer.S
syscall_src += arch-x32/syscalls/__timer_create.S
syscall_src += arch-x32/syscalls/__timer_settime.S
syscall_src += arch-x32/syscalls/__timer_gettime.S
syscall_src += arch-x32/syscalls/__timer_getoverrun.S
syscall_src += arch-x32/syscalls/__timer_delete.S
syscall_src += arch-x32/syscalls/utimes.S
syscall_src += arch-x32/syscalls/sigaction.S
syscall_src += arch-x32/syscalls/sigprocmask.S
syscall_src += arch-x32/syscalls/__sigsuspend.S
syscall_src += arch-x32/syscalls/__rt_sigaction.S
syscall_src += arch-x32/syscalls/__rt_sigprocmask.S
syscall_src += arch-x32/syscalls/__rt_sigtimedwait.S
syscall_src += arch-x32/syscalls/sigpending.S
syscall_src += arch-x32/syscalls/socket.S
syscall_src += arch-x32/syscalls/socketpair.S
syscall_src += arch-x32/syscalls/bind.S
syscall_src += arch-x32/syscalls/connect.S
syscall_src += arch-x32/syscalls/listen.S
syscall_src += arch-x32/syscalls/accept.S
syscall_src += arch-x32/syscalls/getsockname.S
syscall_src += arch-x32/syscalls/getpeername.S
syscall_src += arch-x32/syscalls/sendto.S
syscall_src += arch-x32/syscalls/recvfrom.S
syscall_src += arch-x32/syscalls/shutdown.S
syscall_src += arch-x32/syscalls/setsockopt.S
syscall_src += arch-x32/syscalls/getsockopt.S
syscall_src += arch-x32/syscalls/sendmsg.S
syscall_src += arch-x32/syscalls/recvmsg.S
syscall_src += arch-x32/syscalls/sched_setscheduler.S
syscall_src += arch-x32/syscalls/sched_getscheduler.S
syscall_src += arch-x32/syscalls/sched_yield.S
syscall_src += arch-x32/syscalls/sched_setparam.S
syscall_src += arch-x32/syscalls/sched_getparam.S
syscall_src += arch-x32/syscalls/sched_get_priority_max.S
syscall_src += arch-x32/syscalls/sched_get_priority_min.S
syscall_src += arch-x32/syscalls/sched_rr_get_interval.S
syscall_src += arch-x32/syscalls/ioprio_set.S
syscall_src += arch-x32/syscalls/ioprio_get.S
syscall_src += arch-x32/syscalls/uname.S
syscall_src += arch-x32/syscalls/__wait4.S
syscall_src += arch-x32/syscalls/umask.S
syscall_src += arch-x32/syscalls/__reboot.S
syscall_src += arch-x32/syscalls/__syslog.S
syscall_src += arch-x32/syscalls/init_module.S
syscall_src += arch-x32/syscalls/delete_module.S
syscall_src += arch-x32/syscalls/klogctl.S
syscall_src += arch-x32/syscalls/futex.S
syscall_src += arch-x32/syscalls/epoll_create.S
syscall_src += arch-x32/syscalls/epoll_ctl.S
syscall_src += arch-x32/syscalls/epoll_wait.S
syscall_src += arch-x32/syscalls/inotify_init.S
syscall_src += arch-x32/syscalls/inotify_add_watch.S
syscall_src += arch-x32/syscalls/inotify_rm_watch.S
syscall_src += arch-x32/syscalls/poll.S
