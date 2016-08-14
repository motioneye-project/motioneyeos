################################################################################
#
# gst-dsp
#
################################################################################

GST_DSP_VERSION = v0.10.2
GST_DSP_SITE = $(call github,felipec,gst-dsp,$(GST_DSP_VERSION))

define GST_DSP_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) -e
endef

define GST_DSP_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) -e DESTDIR=$(TARGET_DIR) install
endef

GST_DSP_DEPENDENCIES = gstreamer tidsp-binaries host-pkgconf

$(eval $(generic-package))
