################################################################################
#
# vdr-plugin-vnsiserver
#
################################################################################

VDR_PLUGIN_VNSISERVER_VERSION = v1.5.2
VDR_PLUGIN_VNSISERVER_SITE = $(call github,FernetMenta,vdr-plugin-vnsiserver,$(VDR_PLUGIN_VNSISERVER_VERSION))
VDR_PLUGIN_VNSISERVER_LICENSE = GPL-2.0+
VDR_PLUGIN_VNSISERVER_LICENSE_FILES = COPYING
VDR_PLUGIN_VNSISERVER_DEPENDENCIES = vdr

VDR_PLUGIN_VNSISERVER_CXXFLAGS = CXXFLAGS="$(TARGET_CXXFLAGS) -std=c++11 -fPIC"

define VDR_PLUGIN_VNSISERVER_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) \
		$(VDR_PLUGIN_VNSISERVER_CXXFLAGS)
endef

define VDR_PLUGIN_VNSISERVER_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) \
		install DESTDIR=$(TARGET_DIR) LIBDIR=/usr/lib/vdr
endef

$(eval $(generic-package))
