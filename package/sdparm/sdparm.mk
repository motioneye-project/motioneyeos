################################################################################
#
# sdparm
#
################################################################################

SDPARM_VERSION = 1.09
SDPARM_SOURCE = sdparm-$(SDPARM_VERSION).tar.xz
SDPARM_SITE = http://sg.danny.cz/sg/p
SDPARM_LICENSE = BSD-3c
SDPARM_LICENSE_FILES = COPYING

# Patching src/Makefile.am
SDPARM_AUTORECONF = YES

ifeq ($(BR2_PACKAGE_SG3_UTILS),y)
SDPARM_DEPENDENCIES += sg3_utils
else
SDPARM_CONF_OPTS += --disable-libsgutils
endif

$(eval $(autotools-package))
