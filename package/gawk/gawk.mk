#############################################################
#
# gawk
#
#############################################################

GAWK_VERSION = 3.1.8
GAWK_SITE = $(BR2_GNU_MIRROR)/gawk
GAWK_TARGET_BINS = awk gawk igawk pgawk

$(eval $(call AUTOTARGETS,package,gawk))
$(eval $(call AUTOTARGETS,package,gawk,host))

$(GAWK_HOOK_POST_INSTALL): $(GAWK_TARGET_INSTALL_TARGET)
	ln -sf /usr/bin/gawk $(TARGET_DIR)/usr/bin/awk
	touch $@

$(GAWK_TARGET_UNINSTALL):
	$(call MESSAGE,"Uninstalling")
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/, $(GAWK_TARGET_BINS))
	rm -f $(TARGET_DIR)/usr/share/info/gawk*.info
	rm -f $(TARGET_DIR)/usr/share/man/man*/*gawk.1
	rm -rf $(TARGET_DIR)/usr/libexec/awk
	rm -rf $(TARGET_DIR)/usr/share/awk
	rm -f $(GAWK_TARGET_INSTALL_TARGET) $(GAWK_HOOK_POST_INSTALL)
