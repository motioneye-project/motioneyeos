################################################################################
#
# libpthsem
#
################################################################################

LIBPTHSEM_VERSION = 2.0.8
LIBPTHSEM_SOURCE = pthsem_$(LIBPTHSEM_VERSION).tar.gz
LIBPTHSEM_SITE = http://www.auto.tuwien.ac.at/~mkoegler/pth
LIBPTHSEM_LICENSE = LGPLv2.1+
LIBPTHSEM_LICENSE_FILES = COPYING
LIBPTHSEM_AUTORECONF = YES
LIBPTHSEM_INSTALL_STAGING = YES
LIBPTHSEM_CONFIG_SCRIPTS = pthsem-config

# Force the setjmp/longjmp detection, because the test being done in
# the AC_CHECK_SJLJ macro is not cross-compilation safe: it checks the
# running kernel with 'uname -r', and checks the C library version by
# looking at /usr/include/features.h. In terms of kernel version, it
# assumes any version later than 2.2.x is fine, except that it doesn't
# recognize 4.x as a valid kernel version, recognizing such systems as
# "braindead" and therefore falling back to the 'sjljlx' value for
# ac_cv_check_sjlj. In terms of C library version, it wants
# __GLIBC_MINOR to be at least 1. Since both conditions are true for
# all Buildroot systems, we can simply force the setjmp/longjmp
# detection to ssjlj.
LIBPTHSEM_CONF_ENV += \
	ac_cv_check_sjlj=ssjlj

ifeq ($(BR2_PACKAGE_LIBPTHSEM_COMPAT),y)
LIBPTHSEM_CONF_OPTS += --enable-compat
LIBPTHSEM_CONFIG_SCRIPTS += pth-config
else
LIBPTHSEM_CONF_OPTS += --disable-compat
endif

$(eval $(autotools-package))
