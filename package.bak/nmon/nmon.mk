################################################################################
#
# nmon
#
################################################################################

NMON_VERSION = 16f
NMON_SITE = http://sourceforge.net/projects/nmon/files
NMON_SOURCE = lmon$(NMON_VERSION).c
NMON_LICENSE = GPLv3+
NMON_LICENSE_FILES = $(NMON_SOURCE)
NMON_DEPENDENCIES = ncurses
NMON_CFLAGS = $(TARGET_CFLAGS) -D JFS -D GETUSER -D LARGEMEM -D DEBIAN

define NMON_EXTRACT_CMDS
	cp $(DL_DIR)/$(NMON_SOURCE) $(@D)
endef

define NMON_BUILD_CMDS
	$(TARGET_CC) $(NMON_CFLAGS) $(TARGET_LDFLAGS) -o $(@D)/nmon \
		$(@D)/$(NMON_SOURCE) -lncurses -lm
endef

define NMON_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/nmon $(TARGET_DIR)/usr/bin/
endef

$(eval $(generic-package))
