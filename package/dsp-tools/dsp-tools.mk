################################################################################
#
# dsp-tools
#
################################################################################

DSP_TOOLS_VERSION = 2.0
DSP_TOOLS_SOURCE = dsp-tools-$(DSP_TOOLS_VERSION).tar.gz
DSP_TOOLS_SITE = http://gst-dsp.googlecode.com/files/
DSP_TOOLS_DEPENDENCIES = tidsp-binaries

define DSP_TOOLS_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) -e
endef

define DSP_TOOLS_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) -e DESTDIR=$(TARGET_DIR) install
endef

define DSP_TOOLS_UNINSTALL_TARGET_CMDS
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/dsp-, load probe test exec)
endef

$(eval $(generic-package))
