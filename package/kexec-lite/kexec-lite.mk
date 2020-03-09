################################################################################
#
# kexec-lite
#
################################################################################

KEXEC_LITE_VERSION = 6b0130b3c1ea489e061cda2805e6f8b68dc96a76
KEXEC_LITE_SITE = $(call github,antonblanchard,kexec-lite,$(KEXEC_LITE_VERSION))
KEXEC_LITE_LICENSE = GPL-2.0+
KEXEC_LITE_LICENSE_FILES = COPYING
KEXEC_LITE_DEPENDENCIES = elfutils dtc
KEXEC_LITE_AUTORECONF = YES

$(eval $(autotools-package))
