################################################################################
#
# 4th
#
################################################################################

4TH_VERSION = 3.62.4
4TH_SOURCE = 4th-$(4TH_VERSION)-unix.tar.gz
4TH_SITE = http://downloads.sourceforge.net/project/forth-4th/4th-$(4TH_VERSION)
4TH_LICENSE = GPL-3.0+, LGPL-3.0+
# The COPYING file only contains the text of the LGPL-3.0, but the
# source code really contains parts under GPL-3.0+.
4TH_LICENSE_FILES = COPYING
4TH_DEPENDENCIES = host-4th
4TH_INSTALL_STAGING = YES

4TH_CFLAGS = $(TARGET_CFLAGS) -DUNIX -fsigned-char

ifeq ($(BR2_STATIC_LIBS),y)
4TH_MAKE_ENV = $(TARGET_MAKE_ENV) STATIC=1
else
4TH_MAKE_ENV = $(TARGET_MAKE_ENV) SHARED=1
4TH_CFLAGS += -fPIC
endif

define 4TH_BUILD_CMDS
	$(4TH_MAKE_ENV) $(MAKE) -C $(@D)/sources all \
		CROSS="$(TARGET_CROSS)" \
		CFLAGS="$(4TH_CFLAGS)" \
		FOURTH=$(HOST_DIR)/bin/4th
endef

define 4TH_INSTALL_STAGING_CMDS
	$(4TH_MAKE_ENV) $(MAKE) -C $(@D)/sources libinstall \
		LIBRARIES=$(STAGING_DIR)/usr/lib
	$(INSTALL) -D -m 0644 $(@D)/sources/4th.h \
		$(STAGING_DIR)/usr/include/4th.h
endef

define 4TH_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/bin
	mkdir -p $(TARGET_DIR)/usr/lib
	$(4TH_MAKE_ENV) $(MAKE) -C $(@D)/sources mostlyinstall \
		BINARIES=$(TARGET_DIR)/usr/bin \
		LIBRARIES=$(TARGET_DIR)/usr/lib
	mkdir -p $(TARGET_DIR)/usr/share/4th/lib
	cp -dpf $(@D)/4th/*.4th $(TARGET_DIR)/usr/share/4th
	cp -dpf $(@D)/4th/lib/*.4th $(TARGET_DIR)/usr/share/4th/lib
	mkdir -p $(TARGET_DIR)/usr/share/4th/demo
	cp -dpf $(@D)/4th/demo/*.4th $(TARGET_DIR)/usr/share/4th/demo
	mkdir -p $(TARGET_DIR)/usr/share/4th/4pp/lib
	cp -dpf $(@D)/4th/4pp/*.4pp $(TARGET_DIR)/usr/share/4th/4pp
	cp -dpf $(@D)/4th/4pp/lib/*.4pp $(TARGET_DIR)/usr/share/4th/4pp/lib
endef

define HOST_4TH_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)/sources all \
		CFLAGS="$(HOST_CFLAGS) -DUNIX -fsigned-char"
endef

define HOST_4TH_INSTALL_CMDS
	mkdir -p $(HOST_DIR)/bin
	mkdir -p $(HOST_DIR)/lib
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)/sources mostlyinstall \
		BINARIES=$(HOST_DIR)/bin \
		LIBRARIES=$(HOST_DIR)/lib
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
