################################################################################
#
# libsigsegv
#
################################################################################

LIBSIGSEGV_VERSION = 2.11
LIBSIGSEGV_SITE = $(BR2_GNU_MIRROR)/libsigsegv
LIBSIGSEGV_INSTALL_STAGING = YES
LIBSIGSEGV_CONF_ENV = sv_cv_fault_posix=yes
LIBSIGSEGV_LICENSE = GPL-2.0+
LIBSIGSEGV_LICENSE_FILES = COPYING

$(eval $(autotools-package))
