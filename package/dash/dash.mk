################################################################################
#
# dash
#
################################################################################

DASH_VERSION = 0.5.9.1
DASH_SITE = http://gondor.apana.org.au/~herbert/dash/files
DASH_LICENSE = BSD-3-Clause, GPL-2.0+ (mksignames.c)
DASH_LICENSE_FILES = COPYING

define DASH_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(@D)/src/dash $(TARGET_DIR)/bin/dash
endef

$(eval $(autotools-package))
