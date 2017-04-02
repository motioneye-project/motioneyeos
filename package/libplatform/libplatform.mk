################################################################################
#
# libplatform
#
################################################################################

LIBPLATFORM_VERSION = feafe68e3e0b02c3261aefb3d711863ef6fadd38
LIBPLATFORM_SITE = $(call github,Pulse-Eight,platform,$(LIBPLATFORM_VERSION))
LIBPLATFORM_LICENSE = GPL-2.0+, PHP-3.01
LIBPLATFORM_LICENSE_FILES = src/os.h src/util/fstrcmp.c
LIBPLATFORM_INSTALL_STAGING = YES

$(eval $(cmake-package))
