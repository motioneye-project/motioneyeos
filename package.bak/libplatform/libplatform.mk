################################################################################
#
# libplatform
#
################################################################################

LIBPLATFORM_VERSION = 2.1.0
LIBPLATFORM_SITE = $(call github,Pulse-Eight,platform,p8-platform-$(LIBPLATFORM_VERSION))
LIBPLATFORM_LICENSE = GPLv2+
LIBPLATFORM_LICENSE_FILES = src/os.h
LIBPLATFORM_INSTALL_STAGING = YES

$(eval $(cmake-package))
