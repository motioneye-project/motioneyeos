################################################################################
#
# libplatform
#
################################################################################

LIBPLATFORM_VERSION = 1eb12b1b1efa6747c1e190964854e9e267e3a1e2
LIBPLATFORM_SITE = $(call github,Pulse-Eight,platform,$(LIBPLATFORM_VERSION))
LIBPLATFORM_LICENSE = GPL-2.0+
LIBPLATFORM_LICENSE_FILES = src/os.h
LIBPLATFORM_INSTALL_STAGING = YES

$(eval $(cmake-package))
