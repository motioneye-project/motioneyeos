#############################################################
#
# gawk
#
#############################################################

GAWK_VERSION = 3.1.8
GAWK_SITE = $(BR2_GNU_MIRROR)/gawk
GAWK_TARGET_BINS = awk gawk igawk pgawk

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

$(eval $(call AUTOTARGETS,package,gawk))
$(eval $(call AUTOTARGETS,package,gawk,host))
