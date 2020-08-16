################################################################################
#
# libsigsegv
#
################################################################################

LIBSIGSEGV_VERSION = 2.12
LIBSIGSEGV_SITE = $(BR2_GNU_MIRROR)/libsigsegv
LIBSIGSEGV_INSTALL_STAGING = YES
LIBSIGSEGV_CONF_ENV = sv_cv_fault_posix=yes
LIBSIGSEGV_LICENSE = GPL-2.0+
LIBSIGSEGV_LICENSE_FILES = COPYING
# 0001-Improve-support-for-Linux-RISC-V.patch
# 0002-m4-stack-direction-RISC-V-stack-grows-downward.patch
# 0003-Improve-support-for-Linux-nds32.patch
# 0004-m4-stack-direction-NDS32-stack-grows-downward.patch
LIBSIGSEGV_AUTORECONF = YES

$(eval $(autotools-package))
