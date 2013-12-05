################################################################################
#
# tidsp-binaries
#
################################################################################

TIDSP_BINARIES_VERSION = 23.i3.8
TIDSP_BINARIES_SITE = http://gst-dsp.googlecode.com/files/

define TIDSP_BINARIES_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) -e DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
