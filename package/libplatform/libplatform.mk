################################################################################
#
# libplatform
#
################################################################################

LIBPLATFORM_VERSION = 1.0.10
LIBPLATFORM_SITE = $(call github,Pulse-Eight,platform,$(LIBPLATFORM_VERSION))
LIBPLATFORM_LICENSE = GPLv2+, PHP license v3.01
LIBPLATFORM_LICENSE_FILES = src/os.h src/util/fstrcmp.c
LIBPLATFORM_INSTALL_STAGING = YES

$(eval $(cmake-package))
