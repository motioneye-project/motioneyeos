#############################################################
#
# quagga suite
#
#############################################################
QUAGGA_VERSION:=0.99.8
QUAGGA_SOURCE:=quagga-$(QUAGGA_VERSION).tar.gz
QUAGGA_SITE:=http://www.quagga.net/download
QUAGGA_DIR:=$(BUILD_DIR)/quagga-$(QUAGGA_VERSION)
QUAGGA_CAT:=$(ZCAT)

QUAGGA_CONFIGURE:=
ifeq ($(BR2_PACKAGE_QUAGGA_ZEBRA),y)
QUAGGA_CONFIGURE+=--enable-zebra
ifndef QUAGGA_TARGET_BINARY
QUAGGA_TARGET_BINARY=zebra
QUAGGA_BINARY=$(QUAGGA_DIR)/zebra/.libs/zebra
endif
else
QUAGGA_CONFIGURE+=--disable-zebra
endif
ifeq ($(BR2_PACKAGE_QUAGGA_BGPD),y)
QUAGGA_CONFIGURE+=--enable-bgpd
ifndef QUAGGA_TARGET_BINARY
QUAGGA_TARGET_BINARY=bgpd
QUAGGA_BINARY=$(QUAGGA_DIR)/bgpd/.libs/bgpd
endif
else
QUAGGA_CONFIGURE+=--disable-bgpd
endif
ifeq ($(BR2_PACKAGE_QUAGGA_RIPD),y)
QUAGGA_CONFIGURE+=--enable-ripd
ifndef QUAGGA_TARGET_BINARY
QUAGGA_TARGET_BINARY=ripd
QUAGGA_BINARY=$(QUAGGA_DIR)/ripd/.libs/ripd
endif
else
QUAGGA_CONFIGURE+=--disable-ripd
endif
ifeq ($(BR2_PACKAGE_QUAGGA_RIPNGD),y)
QUAGGA_CONFIGURE+=--enable-ripngd
ifndef QUAGGA_TARGET_BINARY
QUAGGA_TARGET_BINARY=ripngd
QUAGGA_BINARY=$(QUAGGA_DIR)/ripngd/.libs/ripngd
endif
else
QUAGGA_CONFIGURE+=--disable-ripngd
endif
ifeq ($(BR2_PACKAGE_QUAGGA_OSPFD),y)
QUAGGA_CONFIGURE+=--enable-ospfd
ifndef QUAGGA_TARGET_BINARY
QUAGGA_TARGET_BINARY=ospfd
QUAGGA_BINARY=$(QUAGGA_DIR)/ospfd/.libs/ospfd
endif
else
QUAGGA_CONFIGURE+=--disable-ospfd
endif
ifeq ($(BR2_PACKAGE_QUAGGA_OSPF6D),y)
QUAGGA_CONFIGURE+=--enable-ospf6d
ifndef QUAGGA_TARGET_BINARY
QUAGGA_TARGET_BINARY=ospf6d
QUAGGA_BINARY=$(QUAGGA_DIR)/ospf6d/.libs/ospf6d
endif
else
QUAGGA_CONFIGURE+=--disable-ospf6d
endif
ifeq ($(BR2_PACKAGE_QUAGGA_WATCHQUAGGA),y)
QUAGGA_CONFIGURE+=--enable-watchquagga
ifndef QUAGGA_TARGET_BINARY
QUAGGA_TARGET_BINARY=watchquagga
QUAGGA_BINARY=$(QUAGGA_DIR)/watchquagga/.libs/watchquagga
endif
else
QUAGGA_CONFIGURE+=--disable-watchquagga
endif
ifeq ($(BR2_PACKAGE_QUAGGA_ISISD),y)
QUAGGA_CONFIGURE+=--enable-isisd
ifndef QUAGGA_TARGET_BINARY
QUAGGA_TARGET_BINARY=isisd
QUAGGA_BINARY=$(QUAGGA_DIR)/isisd/.libs/isisd
endif
else
QUAGGA_CONFIGURE+=--disable-isisd
endif


ifeq ($(BR2_PACKAGE_QUAGGA_BGP_ANNOUNCE),y)
QUAGGA_CONFIGURE+=--enable-bgp-announce
else
QUAGGA_CONFIGURE+=--disable-bgp-announce
endif
ifeq ($(BR2_PACKAGE_QUAGGA_NETLINK),y)
QUAGGA_CONFIGURE+=--enable-netlink
else
QUAGGA_CONFIGURE+=--disable-netlink
endif
ifeq ($(BR2_PACKAGE_QUAGGA_SNMP),y)
QUAGGA_CONFIGURE+=--enable-snmp
else
QUAGGA_CONFIGURE+=--disable-snmp
endif
ifeq ($(BR2_PACKAGE_QUAGGA_TCP_ZEBRA),y)
QUAGGA_CONFIGURE+=--enable-tcp-zebra
else
QUAGGA_CONFIGURE+=--disable-tcp-zebra
endif
ifeq ($(BR2_PACKAGE_QUAGGA_OPAGUE_LSA),y)
QUAGGA_CONFIGURE+=--enable-opaque-lsa
else
QUAGGA_CONFIGURE+=--disable-opaque-lsa
endif

QUAGGA_CONFIGURE+=$(subst ",,$(BR2_PACKAGE_QUAGGA_CONFIGURE))
# ")

$(DL_DIR)/$(QUAGGA_SOURCE):
	$(WGET) -P $(DL_DIR) $(QUAGGA_SITE)/$(QUAGGA_SOURCE)

ifneq ($(QUAGGA_PATCH),)
QUAGGA_PATCH_FILE=$(DL_DIR)/$(QUAGGA_PATCH)
$(DL_DIR)/$(QUAGGA_PATCH):
	$(WGET) -P $(DL_DIR) $(QUAGGA_SITE)/$(QUAGGA_PATCH)
endif
quagga-source: $(DL_DIR)/$(QUAGGA_SOURCE) $(QUAGGA_PATCH_FILE)

$(QUAGGA_DIR)/.unpacked: $(DL_DIR)/$(QUAGGA_SOURCE) $(DL_DIR)/$(QUAGGA_PATCH)
	$(QUAGGA_CAT) $(DL_DIR)/$(QUAGGA_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(QUAGGA_DIR) package/quagga/ quagga\*.patch
ifneq ($(QUAGGA_PATCH),)
	(cd $(QUAGGA_DIR) && $(QUAGGA_CAT) $(DL_DIR)/$(QUAGGA_PATCH) | patch -p1)
	if [ -d $(QUAGGA_DIR)/debian/patches ]; then \
		toolchain/patch-kernel.sh $(QUAGGA_DIR) $(QUAGGA_DIR)/debian/patches \*.patch; \
	fi
endif
	touch $@

$(QUAGGA_DIR)/.configured: $(QUAGGA_DIR)/.unpacked
	(cd $(QUAGGA_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--sysconfdir=/etc \
		$(DISABLE_LARGEFILE) \
		$(DISABLE_IPV6) \
		$(QUAGGA_CONFIGURE) \
		--program-transform-name='' \
	)
	touch $@

$(QUAGGA_BINARY): $(QUAGGA_DIR)/.configured
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(QUAGGA_DIR)

$(TARGET_DIR)/usr/sbin/$(QUAGGA_TARGET_BINARY): $(QUAGGA_BINARY)
	$(MAKE) DESTDIR=$(TARGET_DIR) -C $(QUAGGA_DIR) install
ifneq ($(BR2_PACKAGE_QUAGGA_HEADERS),y)
	rm -rf $(TARGET_DIR)/usr/include/quagga
endif
ifneq ($(BR2_HAVE_MANPAGES),y)
	rm -rf $(TARGET_DIR)/usr/man $(TARGET_DIR)/usr/info
endif

quagga: uclibc $(TARGET_DIR)/usr/sbin/$(QUAGGA_TARGET_BINARY)

quagga-clean:
	-$(MAKE) DESTDIR=$(TARGET_DIR) -C $(QUAGGA_DIR) uninstall
	-$(MAKE) -C $(QUAGGA_DIR) clean

quagga-dirclean:
	rm -rf $(QUAGGA_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_QUAGGA)),y)
TARGETS+=quagga
endif
