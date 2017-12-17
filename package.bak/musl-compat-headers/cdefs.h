/* Copyright (C) 2016 Yann E. MORIN <yann.morin.1998@free.fr>
 *
 * This file is in the Public Domain.
 *
 * For jurisdictions in which the Public Domain does not exist
 * or it is not otherwise applicable, this file is licensed CC0
 * (Creative Commons Zero).
 */

/* This file contains definitions for non-standard macros defined by
 * glibc, but quite commonly used in packages.
 *
 * Because they are non-standard, musl does not define those macros.
 * It does not provide cdefs.h either.
 *
 * This file is a compatibility header written from scratch, to be
 * installed when the C library is musl.
 *
 * Not all macros from the glibc's cdefs.h are available, only the
 * most commonly used ones.
 *
 * Please refer to the glibc documentation and source code for
 * explanations about those macros.
 */

#ifndef BUILDROOT_SYS_CDEFS_H
#define BUILDROOT_SYS_CDEFS_H

/* Function prototypes. */
#undef __P
#define __P(arg) arg

/* C declarations in C++ mode. */
#ifdef __cplusplus
# define __BEGIN_DECLS extern "C" {
# define __END_DECLS   }
#else
# define __BEGIN_DECLS
# define __END_DECLS
#endif

/* Don't throw exceptions in C functions. */
#ifndef __cplusplus
# define __THROW  __attribute__ ((__nothrow__))
# define __NTH(f) __attribute__ ((__nothrow__)) f
#else
# define __THROW
# define __NTH(f) f
#endif

#endif /* ifndef BUILDROOT_SYS_CDEFS_H */
