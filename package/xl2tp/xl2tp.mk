################################################################################
#
# xl2tp
#
################################################################################

XL2TP_VERSION = v1.3.8
XL2TP_SITE = $(call github,xelerance,xl2tpd,$(XL2TP_VERSION))
XL2TP_DEPENDENCIES = libpcap openssl
XL2TP_LICENSE = GPL-2.0
XL2TP_LICENSE_FILES = LICENSE

ifeq ($(BR2_STATIC_LIBS),y)
XL2TP_LDLIBS = LDLIBS="`$(STAGING_DIR)/usr/bin/pcap-config --static --additional-libs`"
endif

define XL2TP_BUILD_CMDS
	$(SED) 's/ -O2 //' $(@D)/Makefile
	$(TARGET_CONFIGURE_OPTS) $(MAKE) $(XL2TP_LDLIBS) -C $(@D)
endef

define XL2TP_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) DESTDIR=$(TARGET_DIR) PREFIX=/usr -C $(@D) install
endef

$(eval $(generic-package))
