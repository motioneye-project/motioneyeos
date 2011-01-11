#############################################################
#
# wipe
#
#############################################################

WIPE_VERSION = 0.22
WIPE_SITE = http://lambda-diode.com/resources/wipe
WIPE_CFLAGS = $(TARGET_CFLAGS) -DHAVE_DEV_URANDOM -DHAVE_OSYNC -DHAVE_STRCASECMP -DHAVE_RANDOM -DSYNC_WAITS_FOR_SYNC -DFIND_DEVICE_SIZE_BY_BLKGETSIZE

ifeq ($(BR2_LARGEFILE),y)
WIPE_CFLAGS += -DSIXTYFOUR
endif

define WIPE_BUILD_CMDS
	# Fix busted git version logic
	$(SED) "s/which/!which/" $(@D)/Makefile
	$(MAKE) -C $(@D) linux CC_LINUX="$(TARGET_CC)" \
		CCO_LINUX="$(WIPE_CFLAGS)"
endef

define WIPE_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/wipe $(TARGET_DIR)/usr/bin/wipe
	$(INSTALL) -D $(@D)/wipe.1 $(TARGET_DIR)/usr/share/man/man1/wipe.1
endef

define WIPE_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/bin/wipe
	rm -f $(TARGET_DIR)/usr/share/man/man1/wipe.1
endef

define WIPE_CLEAN_CMDS
	$(MAKE) -C $(@D) clean
endef

$(eval $(call GENTARGETS,package,wipe))
