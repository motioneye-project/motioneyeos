################################################################################
#
# ustr
#
################################################################################

USTR_VERSION = 1.0.4
USTR_SOURCE = ustr-$(USTR_VERSION).tar.bz2
USTR_SITE = http://www.and.org/ustr/$(USTR_VERSION)
USTR_LICENSE = BSD-2c MIT LGPLv2+
USTR_LICENSE_FILES = LICENSE LICENSE_BSD LICENSE_LGPL LICENSE_MIT

USTR_INSTALL_STAGING = YES

ifeq ($(BR2_STATIC_LIBS),y)
USTR_BUILD_TARGETS = all
USTR_INSTALL_TARGETS = install
else ifeq ($(BR2_SHARED_LIBS),y)
USTR_BUILD_TARGETS = all-shared
USTR_INSTALL_TARGETS = install-shared
else
USTR_BUILD_TARGETS = all all-shared
USTR_INSTALL_TARGETS = all install-shared
endif

define USTR_BUILD_CMDS
	$(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS) $(USTR_BUILD_TARGETS)
endef

define USTR_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS) DESTDIR=$(STAGING_DIR) \
		$(USTR_INSTALL_TARGETS)
	$(RM) -f $(STAGING_DIR)/usr/lib/libustr-debug*
	$(RM) -f $(STAGING_DIR)/usr/lib/pkgconfig/libustr-debug.pc
endef

define USTR_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS) DESTDIR=$(TARGET_DIR) \
		$(USTR_INSTALL_TARGETS)
	$(RM) -f $(TARGET_DIR)/usr/lib/libustr-debug*
	$(RM) -rf $(TARGET_DIR)/usr/share/ustr-$(USTR_VERSION)
endef

define HOST_USTR_BUILD_CMDS
	$(MAKE) -C $(@D) $(HOST_CONFIGURE_OPTS) all-shared
endef

define HOST_USTR_INSTALL_CMDS
	$(MAKE) -C $(@D) $(HOST_CONFIGURE_OPTS) DESTDIR=$(HOST_DIR) \
		install-shared
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
