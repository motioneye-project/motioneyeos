#############################################################
#
# bridgeutils - User Space Program For Controlling Bridging
#
#############################################################
#
BRIDGE_VERSION=1.0.6
BRIDGE_SOURCE_URL=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/bridge/
BRIDGE_SOURCE=bridge-utils-$(BRIDGE_VERSION).tar.gz
BRIDGE_BUILD_DIR=$(BUILD_DIR)/bridge-utils-$(BRIDGE_VERSION)
BRIDGE_TARGET_BINARY:=usr/sbin/brctl

$(DL_DIR)/$(BRIDGE_SOURCE):
	 $(WGET) -P $(DL_DIR) $(BRIDGE_SOURCE_URL)/$(BRIDGE_SOURCE)

$(BRIDGE_BUILD_DIR)/.unpacked: $(DL_DIR)/$(BRIDGE_SOURCE)
	$(ZCAT) $(DL_DIR)/$(BRIDGE_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	patch -p1 -d $(BRIDGE_BUILD_DIR) < package/bridge/bridge.patch
	touch $(BRIDGE_BUILD_DIR)/.unpacked

$(BRIDGE_BUILD_DIR)/.configured: $(BRIDGE_BUILD_DIR)/.unpacked
	(cd $(BRIDGE_BUILD_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libdir=/lib \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--mandir=/usr/man \
		--infodir=/usr/info \
		$(DISABLE_NLS) \
		--with-linux-headers=$(LINUX_HEADERS_DIR) \
	)
	touch $(BRIDGE_BUILD_DIR)/.configured

$(BRIDGE_BUILD_DIR)/brctl/brctl: $(BRIDGE_BUILD_DIR)/.configured
	$(MAKE) -C $(BRIDGE_BUILD_DIR)

$(TARGET_DIR)/$(BRIDGE_TARGET_BINARY): $(BRIDGE_BUILD_DIR)/brctl/brctl
	cp -af $(BRIDGE_BUILD_DIR)/brctl/brctl $(TARGET_DIR)/$(BRIDGE_TARGET_BINARY)
	$(STRIPCMD) $(TARGET_DIR)/$(BRIDGE_TARGET_BINARY)
	#cp -af $(BRIDGE_BUILD_DIR)/brctl/brctld $(TARGET_DIR)/usr/sbin/
	#$(STRIPCMD) $(TARGET_DIR)/usr/sbin/brctld

bridge-utils: $(TARGET_DIR)/$(BRIDGE_TARGET_BINARY)

bridge-utils-source: $(DL_DIR)/$(BRIDGE_SOURCE)

bridge-utils-clean:
	#$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(BRIDGE_BUILD_DIR) uninstall
	-$(MAKE) -C $(BRIDGE_BUILD_DIR) clean

bridge-utils-dirclean:
	rm -rf $(BRIDGE_BUILD_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_BRIDGE)),y)
TARGETS+=bridge-utils
endif
