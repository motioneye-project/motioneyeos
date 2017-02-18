################################################################################
#
# unscd
#
################################################################################

UNSCD_VERSION = 0.52
UNSCD_SOURCE = nscd-$(UNSCD_VERSION).c
UNSCD_SITE = http://busybox.net/~vda/unscd
UNSCD_LICENSE = GPLv2
UNSCD_LICENSE_FILES = $(UNSCD_SOURCE)

define UNSCD_EXTRACT_CMDS
	cp $(DL_DIR)/$($(PKG)_SOURCE) $(@D)/
endef

define UNSCD_BUILD_CMDS
	cd $(@D); \
	$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) -o nscd $(UNSCD_SOURCE)
endef

define UNSCD_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 -D $(@D)/nscd $(TARGET_DIR)/usr/sbin/nscd
	$(INSTALL) -m 600 -D package/unscd/nscd.conf $(TARGET_DIR)/etc/nscd.conf
endef

define UNSCD_INSTALL_INIT_SYSV
	$(INSTALL) -m 755 -D package/unscd/S46unscd \
		$(TARGET_DIR)/etc/init.d/S46unscd
endef

define UNSCD_USERS
	unscd -1 unscd -1 * - - - unscd user
endef

$(eval $(generic-package))
