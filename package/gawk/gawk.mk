#############################################################
#
# gawk
#
#############################################################

GAWK_VERSION = 4.0.1
GAWK_SITE = $(BR2_GNU_MIRROR)/gawk
GAWK_TARGET_BINS = awk gawk igawk pgawk

# Prefer full-blown gawk over busybox awk
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
GAWK_DEPENDENCIES += busybox
endif

# we don't have a host-busybox
HOST_GAWK_DEPENDENCIES =

define GAWK_CREATE_SYMLINK
	ln -sf /usr/bin/gawk $(TARGET_DIR)/usr/bin/awk
endef

GAWK_POST_INSTALL_TARGET_HOOKS += GAWK_CREATE_SYMLINK

define GAWK_UNINSTALL_TARGET_CMDS
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/, $(GAWK_TARGET_BINS))
	rm -f $(TARGET_DIR)/usr/share/info/gawk*.info
	rm -f $(TARGET_DIR)/usr/share/man/man*/*gawk.1
	rm -rf $(TARGET_DIR)/usr/libexec/awk
	rm -rf $(TARGET_DIR)/usr/share/awk
endef

$(eval $(autotools-package))
$(eval $(host-autotools-package))
