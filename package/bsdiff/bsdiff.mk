################################################################################
#
# bsdiff
#
################################################################################

BSDIFF_VERSION = 4.3
BSDIFF_SOURCE = bsdiff-$(BSDIFF_VERSION).tar.gz
BSDIFF_SITE = http://www.daemonology.net/bsdiff
BSDIFF_DEPENDENCIES = bzip2

define BSDIFF_BUILD_CMDS
	$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) \
		$(@D)/bsdiff.c -lbz2 -o $(@D)/bsdiff
	$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) \
		$(@D)/bspatch.c -lbz2 -o $(@D)/bspatch
endef

define BSDIFF_INSTALL_TARGET_CMDS
	install -D -m 755 $(@D)/bsdiff $(TARGET_DIR)/usr/bin/bsdiff
	install -D -m 755 $(@D)/bspatch $(TARGET_DIR)/usr/bin/bspatch
endef

define BSDIFF_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/bin/bsdiff $(TARGET_DIR)/usr/bin/bspatch
endef

define BSDIFF_CLEAN_CMDS
	rm -f $(@D)/bsdiff $(@D)/bspatch
endef

$(eval $(generic-package))
