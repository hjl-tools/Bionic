#include <signal.h>

extern void __rt_sigreturn(void);
extern int __rt_sigaction(int, const struct sigaction *, struct sigaction *,
			     size_t);

int sigaction(int sig, const struct sigaction *act, struct sigaction *oact)
{
	int rv;
	struct sigaction sa;

	if (act && !(act->sa_flags & SA_RESTORER)) {
		sa = *act;
		act = &sa;

		/* The kernel can't be trusted to have a valid default
		   restorer */
		sa.sa_flags |= SA_RESTORER;
		sa.sa_restorer = &__rt_sigreturn;
	}

	rv = __rt_sigaction(sig, act, oact, sizeof(sigset_t));

	if (oact && (oact->sa_restorer == &__rt_sigreturn)) {
		oact->sa_flags &= ~SA_RESTORER;
	}

	return rv;
}
