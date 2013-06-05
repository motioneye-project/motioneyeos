################################################################################
#
# xl2tp
#
################################################################################

XL2TP_VERSION = v1.3.1
XL2TP_SITE = http://github.com/xelerance/xl2tpd/tarball/$(XL2TP_VERSION)
XL2TP_DEPENDENCIES = libpcap

define XL2TP_BUILD_CMDS
	$(SED) 's/ -O2 //' $(@D)/Makefile
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define XL2TP_INSTALL_TARGET_CMDS
	$(MAKE) DESTDIR=$(TARGET_DIR) PREFIX=/usr -C $(@D) install
endef

$(eval $(generic-package))
