/* Program version */
#define VERSION "5.0.26"

/* Configurable features */

/* Always hide legal disclaimers */
#undef ALWAYS_HIDE_DISCL

/* Default server */
#define DEFAULTSERVER   "whois.arin.net"

/* Configuration file */
/*
#define CONFIG_FILE "/etc/whois.conf"
*/


/* autoconf in cpp macros */
#ifdef linux
# define ENABLE_NLS
#endif

#ifdef __FreeBSD__
/* which versions? */
# define HAVE_GETOPT_LONG
# define HAVE_GETADDRINFO
# define ENABLE_NLS
# ifndef LOCALEDIR
#  define LOCALEDIR "/usr/local/share/locale"
# endif
#endif

/* needs unistd.h */
#if defined _POSIX_C_SOURCE && _POSIX_C_SOURCE >= 200112L
# define HAVE_GETADDRINFO
# define HAVE_REGEXEC
#endif

#if defined __APPLE__ && defined __MACH__
# define HAVE_GETOPT_LONG
# define HAVE_GETADDRINFO
#endif

#if defined __GLIBC__
# define HAVE_GETOPT_LONG
# if __GLIBC__ >= 2 && __GLIBC_MINOR__ >= 1
#  define HAVE_GETADDRINFO
# endif
# if __GLIBC__ >= 2 && __GLIBC_MINOR__ >= 7
#  define HAVE_SHA_CRYPT
# endif
#endif

/* Unknown versions of Solaris */
#if defined __SVR4 && defined __sun
# define HAVE_SHA_CRYPT
# define HAVE_SOLARIS_CRYPT_GENSALT
#endif

/* FIXME: which systems lack this? */
#define HAVE_GETTIMEOFDAY
/* FIXME: disabled because it does not parse addresses with a netmask length.
 * The code using it needs to be either fixed or removed.
#define HAVE_INET_PTON
*/

/*
 * Please send patches to correctly ignore old releases which lack a RNG
 * and add more systems which have one.
 */
#ifdef RANDOM_DEVICE
#elif defined __GLIBC__ \
	|| defined __FreeBSD__ || defined __NetBSD__ || defined __OpenBSD__ \
	/* AIX >= 5.2? */ \
	|| defined _AIX52 \
	/* HP-UX >= B.11.11.09? */ \
	|| defined  __hpux \
	/* OS X: */ \
	|| (defined __APPLE__ && defined __MACH__) \
	/* Solaris >= 9 (this is >= 7): */ \
	|| (defined __SVR4 && defined __sun && defined SUSv2) \
	/* Tru64 UNIX >= 5.1B? */ \
	|| defined __osf
# define RANDOM_DEVICE "/dev/urandom"
#endif

#ifdef ENABLE_NLS
# ifndef NLS_CAT_NAME
#  define NLS_CAT_NAME   "whois"
# endif
# ifndef LOCALEDIR
#  define LOCALEDIR     "/usr/share/locale"
# endif
#endif

