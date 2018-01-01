################################################################################
#
# sdparm
#
################################################################################

SDPARM_VERSION = 1.10
SDPARM_SOURCE = sdparm-$(SDPARM_VERSION).tar.xz
SDPARM_SITE = http://sg.danny.cz/sg/p
SDPARM_LICENSE = BSD-3-Clause
SDPARM_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_SG3_UTILS),y)
SDPARM_DEPENDENCIES += sg3_utils
else
SDPARM_CONF_OPTS += --disable-libsgutils
endif

$(eval $(autotools-package))
