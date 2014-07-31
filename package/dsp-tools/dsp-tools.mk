################################################################################
#
# dsp-tools
#
################################################################################

DSP_TOOLS_VERSION = 2.0
DSP_TOOLS_SITE = http://gst-dsp.googlecode.com/files
DSP_TOOLS_DEPENDENCIES = tidsp-binaries
DSP_TOOLS_LICENSE = LGPLv2.1
DSP_TOOLS_LICENSE_FILES = LICENSE

define DSP_TOOLS_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) -e
endef

define DSP_TOOLS_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) -e DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
