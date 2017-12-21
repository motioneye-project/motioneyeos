################################################################################
#
# bsdiff
#
################################################################################

BSDIFF_VERSION = 4.3
BSDIFF_SITE = http://www.daemonology.net/bsdiff
BSDIFF_DEPENDENCIES = bzip2
BSDIFF_LICENSE = BSD-2-Clause
BSDIFF_LICENSE_FILES = bsdiff.c

define BSDIFF_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) \
		$(@D)/bsdiff.c -lbz2 -o $(@D)/bsdiff
	$(TARGET_MAKE_ENV) $(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) \
		$(@D)/bspatch.c -lbz2 -o $(@D)/bspatch
endef

define BSDIFF_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/bsdiff $(TARGET_DIR)/usr/bin/bsdiff
	$(INSTALL) -D -m 755 $(@D)/bspatch $(TARGET_DIR)/usr/bin/bspatch
endef

$(eval $(generic-package))
