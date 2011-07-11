#############################################################
#
# ebtables
#
#############################################################
EBTABLES_VERSION = 2.0.10-1
EBTABLES_SOURCE = ebtables-v$(EBTABLES_VERSION).tar.gz
EBTABLES_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/ebtables

define EBTABLES_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) LIBDIR=/lib/ebtables -C $(@D)
endef

define EBTABLES_INSTALL_TARGET_CMDS
	for so in $(@D)/$(EBTABLES_SUBDIR)/*.so \
		$(@D)/$(EBTABLES_SUBDIR)/extensions/*.so; \
		do \
		$(INSTALL) -m 0755 -D $${so} \
			$(TARGET_DIR)/lib/ebtables/`basename $${so}`; \
	done
	$(INSTALL) -m 0755 -D $(@D)/$(EBTABLES_SUBDIR)/ebtables \
		$(TARGET_DIR)/sbin/ebtables
endef

define EBTABLES_UNINSTALL_TARGET_CMDS
	rm -rf $(TARGET_DIR)/lib/ebtables
	rm -f $(TARGET_DIR)/sbin/ebtables
endef

$(eval $(call GENTARGETS,package,ebtables))
