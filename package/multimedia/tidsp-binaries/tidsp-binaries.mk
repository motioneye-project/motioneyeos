TIDSP_BINARIES_VERSION=23.i3.8
TIDSP_BINARIES_SOURCE=tidsp-binaries-$(TIDSP_BINARIES_VERSION).tar.gz
TIDSP_BINARIES_SITE:=http://gst-dsp.googlecode.com/files/

define TIDSP_BINARIES_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) -e DESTDIR=$(TARGET_DIR) install
endef

define TIDSP_BINARIES_UNINSTALL_TARGET_CMDS
	$(RM) -r $(TARGET_DIR)/lib/dsp
endef

$(eval $(generic-package))
