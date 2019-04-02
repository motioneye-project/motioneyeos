################################################################################
#
# vdr-plugin-vnsiserver
#
################################################################################

VDR_PLUGIN_VNSISERVER_VERSION = 1.8.0
VDR_PLUGIN_VNSISERVER_SITE = $(call github,FernetMenta,vdr-plugin-vnsiserver,v$(VDR_PLUGIN_VNSISERVER_VERSION))
VDR_PLUGIN_VNSISERVER_LICENSE = GPL-2.0+
VDR_PLUGIN_VNSISERVER_LICENSE_FILES = COPYING
VDR_PLUGIN_VNSISERVER_DEPENDENCIES = vdr

VDR_PLUGIN_VNSISERVER_CXXFLAGS = CXXFLAGS="$(TARGET_CXXFLAGS) -std=c++11 -fPIC"

VDR_PLUGIN_VNSISERVER_INSTALL_TARGETS = install-lib
ifeq ($(BR2_SYSTEM_ENABLE_NLS),y)
VDR_PLUGIN_VNSISERVER_INSTALL_TARGETS += install-i18n
endif

define VDR_PLUGIN_VNSISERVER_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) \
		$(VDR_PLUGIN_VNSISERVER_CXXFLAGS)
endef

define VDR_PLUGIN_VNSISERVER_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) \
		$(VDR_PLUGIN_VNSISERVER_INSTALL_TARGETS) DESTDIR=$(TARGET_DIR) \
		LIBDIR=/usr/lib/vdr LOCDIR=/usr/share/locale
endef

$(eval $(generic-package))
