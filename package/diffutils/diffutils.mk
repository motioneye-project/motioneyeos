################################################################################
#
# diffutils
#
################################################################################

DIFFUTILS_VERSION = 3.6
DIFFUTILS_SOURCE = diffutils-$(DIFFUTILS_VERSION).tar.xz
DIFFUTILS_SITE = $(BR2_GNU_MIRROR)/diffutils
DIFFUTILS_DEPENDENCIES = $(TARGET_NLS_DEPENDENCIES)
DIFFUTILS_LICENSE = GPL-3.0+
DIFFUTILS_LICENSE_FILES = COPYING

# Since glibc >= 2.26, don't try to use getopt_long replacement bundled
# with diffutils. It will conflict with the one from glibc.
ifeq ($(BR2_TOOLCHAIN_USES_GLIBC),y)
DIFFUTILS_CONF_ENV += gl_cv_func_getopt_gnu=yes
endif

ifeq ($(BR2_PACKAGE_BUSYBOX),y)
DIFFUTILS_DEPENDENCIES += busybox
endif

$(eval $(autotools-package))
