#############################################################
#
# netplug
#
#############################################################
NETPLUG_VER=1.2.9
NETPLUG_SOURCE=netplug-$(NETPLUG_VER).tar.bz2
NETPLUG_SITE=http://www.red-bean.com/~bos/netplug
NETPLUG_DIR=$(BUILD_DIR)/netplug-$(NETPLUG_VER)
NETPLUG_CAT:=$(BZCAT)
NETPLUG_BINARY:=netplugd
NETPLUG_TARGET_BINARY:=sbin/netplugd

$(DL_DIR)/$(NETPLUG_SOURCE):
	$(WGET) -P $(DL_DIR) $(NETPLUG_SITE)/$(NETPLUG_SOURCE)

netplug-source: $(DL_DIR)/$(NETPLUG_SOURCE)

$(NETPLUG_DIR)/.unpacked: $(DL_DIR)/$(NETPLUG_SOURCE)
	$(NETPLUG_CAT) $(DL_DIR)/$(NETPLUG_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(NETPLUG_DIR) package/netplug/ netplug\*.patch
	touch $(NETPLUG_DIR)/.unpacked

$(NETPLUG_DIR)/$(NETPLUG_BINARY): $(NETPLUG_DIR)/.unpacked
	$(MAKE) CC=$(TARGET_CC) -C $(NETPLUG_DIR)
	$(STRIP) $(NETPLUG_DIR)/$(NETPLUG_BINARY)

$(TARGET_DIR)/$(NETPLUG_TARGET_BINARY): $(NETPLUG_DIR)/$(NETPLUG_BINARY)
	$(INSTALL) -m 644 -D $(NETPLUG_DIR)/etc/netplugd.conf $(TARGET_DIR)/etc/netplug/netplugd.conf
	$(INSTALL) -m 755 -D package/netplug/netplug-script $(TARGET_DIR)/etc/netplug.d/netplug
	$(INSTALL) -m 755 -D package/netplug/S29netplug $(TARGET_DIR)/etc/init.d
	$(INSTALL) -m 755 -D $(NETPLUG_DIR)/$(NETPLUG_BINARY) $(TARGET_DIR)/$(NETPLUG_TARGET_BINARY)
	touch -c $(TARGET_DIR)/$(NETPLUG_TARGET_BINARY)

netplug: uclibc $(TARGET_DIR)/$(NETPLUG_TARGET_BINARY)

netplug-clean:
	rm -f $(TARGET_DIR)/$(NETPLUG_TARGET_BINARY)
	rm -rf $(TARGET_DIR)/etc/netplug*
	rm -f $(TARGET_DIR)/etc/init.d/S*netplug
	-$(MAKE) -C $(NETPLUG_DIR) clean

netplug-dirclean:
	rm -rf $(NETPLUG_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_NETPLUG)),y)
TARGETS+=netplug
endif
