################################################################################
#
# dash
#
################################################################################

DASH_VERSION = 0.5.8
DASH_SOURCE = dash_$(DASH_VERSION).orig.tar.gz
DASH_SITE = http://snapshot.debian.org/archive/debian/20141023T043132Z/pool/main/d/dash
DASH_PATCH = dash_$(DASH_VERSION)-1.diff.gz
DASH_LICENSE = BSD-3c, GPLv2+ (mksignames.c)
DASH_LICENSE_FILES = COPYING

# 0002-fix-parallel-build.patch
DASH_AUTORECONF = YES

define DASH_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(@D)/src/dash $(TARGET_DIR)/bin/dash
endef

$(eval $(autotools-package))
