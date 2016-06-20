#############################################################
#
# fwup
#
#############################################################

FWUP_VERSION = v0.8.0
FWUP_SITE = $(call github,fhunleth,fwup,$(FWUP_VERSION))
FWUP_LICENSE = Apache-2.0
FWUP_LICENSE_FILES = LICENSE
FWUP_DEPENDENCIES = libconfuse libarchive libsodium
FWUP_AUTORECONF = YES

$(eval $(autotools-package))
$(eval $(host-autotools-package))
