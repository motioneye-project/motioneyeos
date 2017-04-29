################################################################################
#
# libplatform
#
################################################################################

LIBPLATFORM_VERSION = 2d90f98620e25f47702c9e848380c0d93f29462b
LIBPLATFORM_SITE = $(call github,Pulse-Eight,platform,$(LIBPLATFORM_VERSION))
LIBPLATFORM_LICENSE = GPL-2.0+
LIBPLATFORM_LICENSE_FILES = src/os.h
LIBPLATFORM_INSTALL_STAGING = YES

$(eval $(cmake-package))
