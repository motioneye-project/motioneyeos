################################################################################
#
# gst-omapfb
#
################################################################################

GST_OMAPFB_VERSION = v1.0
GST_OMAPFB_SITE = $(call github,felipec,gst-omapfb,$(GST_OMAPFB_VERSION))

define GST_OMAPFB_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) -e
endef

define GST_OMAPFB_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) -e DESTDIR=$(TARGET_DIR) install
endef

GST_OMAPFB_DEPENDENCIES = gstreamer

$(eval $(generic-package))
