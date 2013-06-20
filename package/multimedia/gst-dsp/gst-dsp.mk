################################################################################
#
# gst-dsp
#
################################################################################

GST_DSP_VERSION = 0.10.2
GST_DSP_SITE = http://gst-dsp.googlecode.com/files/

define GST_DSP_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) -e
endef

define GST_DSP_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) -e DESTDIR=$(TARGET_DIR) install
endef

define GST_DSP_UNINSTALL_TARGET_CMDS
	$(RM) $(TARGET_DIR)/usr/lib/gstreamer-0.10/libgstdsp.so
endef

GST_DSP_DEPENDENCIES = gstreamer tidsp-binaries host-pkgconf

$(eval $(generic-package))
