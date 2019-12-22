################################################################################
#
# ebtables
#
################################################################################

EBTABLES_VERSION = 2.0.10-4
EBTABLES_SOURCE = ebtables-v$(EBTABLES_VERSION).tar.gz
EBTABLES_SITE = http://ftp.netfilter.org/pub/ebtables
EBTABLES_LICENSE = GPL-2.0+
EBTABLES_LICENSE_FILES = COPYING
EBTABLES_STATIC = $(if $(BR2_STATIC_LIBS),static)
EBTABLES_K64U32 = $(if $(BR2_KERNEL_64_USERLAND_32),-DKERNEL_64_USERSPACE_32)

define EBTABLES_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) LIBDIR=/lib/ebtables $(EBTABLES_STATIC) \
		CFLAGS="$(TARGET_CFLAGS) $(EBTABLES_K64U32)" -C $(@D)
endef

ifeq ($(BR2_STATIC_LIBS),y)
define EBTABLES_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/static $(TARGET_DIR)/sbin/ebtables
endef
else
define EBTABLES_INSTALL_TARGET_CMDS
	for so in $(@D)/*.so $(@D)/extensions/*.so; do \
		$(INSTALL) -m 0755 -D $${so} \
			$(TARGET_DIR)/lib/ebtables/`basename $${so}` || exit 1; \
	done
	$(INSTALL) -m 0755 -D $(@D)/ebtables $(TARGET_DIR)/sbin/ebtables
	$(INSTALL) -m 0644 -D $(@D)/ethertypes $(TARGET_DIR)/etc/ethertypes
endef
endif

$(eval $(generic-package))
