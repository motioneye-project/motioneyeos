################################################################################
#
# kexec-lite
#
################################################################################

KEXEC_LITE_VERSION = 18ec88310c4134eca2f9e3c417cd09f5914bf633
KEXEC_LITE_SITE = $(call github,antonblanchard,kexec-lite,$(KEXEC_LITE_VERSION))
KEXEC_LITE_LICENSE = GPL-2.0+
KEXEC_LITE_LICENSE_FILES = COPYING
KEXEC_LITE_DEPENDENCIES = elfutils dtc
KEXEC_LITE_AUTORECONF = YES

$(eval $(autotools-package))
