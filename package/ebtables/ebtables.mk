################################################################################
#
# ebtables
#
################################################################################

EBTABLES_VERSION = 2.0.10-4
EBTABLES_SOURCE = ebtables-v$(EBTABLES_VERSION).tar.gz
EBTABLES_SITE = http://downloads.sourceforge.net/project/ebtables/ebtables/ebtables-$(subst .,-,$(EBTABLES_VERSION))
EBTABLES_LICENSE = GPLv2+
EBTABLES_LICENSE_FILES = COPYING
EBTABLES_STATIC = $(if $(BR2_PREFER_STATIC_LIB),static)

define EBTABLES_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) LIBDIR=/lib/ebtables $(EBTABLES_STATIC) \
		-C $(@D)
endef

ifeq ($(BR2_PREFER_STATIC_LIB),y)
define EBTABLES_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/$(EBTABLES_SUBDIR)/static \
		$(TARGET_DIR)/sbin/ebtables
endef
else
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
endif

define EBTABLES_UNINSTALL_TARGET_CMDS
	rm -rf $(TARGET_DIR)/lib/ebtables
	rm -f $(TARGET_DIR)/sbin/ebtables
endef

$(eval $(generic-package))
