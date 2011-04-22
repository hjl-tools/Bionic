	.section .preinit_array, "aw"
	.long 0

	.section .init_array, "aw"
	.long 0

	.section .fini_array, "aw"
	.long 0

#ifndef NO_CTORS_SECTIONS
	.section .ctors, "aw"
	.long 0
#endif
