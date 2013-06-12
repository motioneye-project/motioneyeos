################################################################################
#
# sdparm
#
################################################################################

SDPARM_VERSION = 1.08
SDPARM_SOURCE = sdparm-$(SDPARM_VERSION).tgz
SDPARM_SITE = http://sg.danny.cz/sg/p
SDPARM_LICENSE = BSD-3c
SDPARM_LICENSE_FILES = COPYING

$(eval $(autotools-package))
