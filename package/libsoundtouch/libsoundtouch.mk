################################################################################
#
# libsoundtouch
#
################################################################################

LIBSOUNDTOUCH_VERSION = 010a91a59071c7fefd316fca62c0d980ec85b4b1
LIBSOUNDTOUCH_SITE = https://freeswitch.org/stash/scm/sd/libsoundtouch.git
LIBSOUNDTOUCH_SITE_METHOD = git
LIBSOUNDTOUCH_LICENSE = LGPLv2.1+
LIBSOUNDTOUCH_LICENSE_FILES = COPYING.TXT
LIBSOUNDTOUCH_AUTORECONF = YES
LIBSOUNDTOUCH_INSTALL_STAGING = YES

define LIBSOUNDTOUCH_CREATE_CONFIG_M4
	mkdir -p $(@D)/config/m4
endef
LIBSOUNDTOUCH_POST_PATCH_HOOKS += LIBSOUNDTOUCH_CREATE_CONFIG_M4

$(eval $(autotools-package))
