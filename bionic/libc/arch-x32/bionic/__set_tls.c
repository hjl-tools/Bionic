/*
 * Copyright (C) 2008 The Android Open Source Project
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *  * Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *  * Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
 * AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */
#include <pthread.h>
#include <asm/prctl.h>

static unsigned long _tls_desc;

static pthread_mutex_t  _tls_desc_lock = PTHREAD_MUTEX_INITIALIZER;

struct _thread_area_head {
    void *self;
};

extern int __arch_prctl(int, unsigned long *);

/* we implement thread local storage through the fs: segment descriptor
 * we create a segment descriptor for the tls
 */
int __set_tls(void *ptr)
{
    int   rc, segment;

    pthread_mutex_lock(&_tls_desc_lock);
    _tls_desc = (unsigned long)ptr;

    /* We also need to write the location of the tls to ptr[0] */
    ((struct _thread_area_head *)ptr)->self = ptr;

    rc = __arch_prctl (ARCH_SET_FS, &_tls_desc );
    if (rc != 0)
    {
        /* could not set thread local area */
        return -1;
    }

    pthread_mutex_unlock(&_tls_desc_lock);

    return 0;
}



