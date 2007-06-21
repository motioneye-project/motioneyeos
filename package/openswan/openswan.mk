#############################################################
#
# openswan
#
# NOTE: Uses start-stop-daemon in init script, so be sure
# to enable that within busybox
#
#############################################################
OPENSWAN_VERSION:=2.4.8
OPENSWAN_SOURCE:=openswan-$(OPENSWAN_VERSION).tar.gz
OPENSWAN_SITE:=http://www.openswan.org/download/
OPENSWAN_DIR:=$(BUILD_DIR)/openswan-$(OPENSWAN_VERSION)
OPENSWAN_CAT:=$(ZCAT)
OPENSWAN_BINARY:=programs/pluto/pluto
OPENSWAN_TARGET_BINARY:=usr/sbin/ipsec

ifneq ($(BR2_PACKAGE_OPENSWAN_DEBUGGING),y)
OPENSWAN_CFLAGS=-UDEBUG -DNO_DEBUG -ULEAK_DETECTIVE
endif

$(DL_DIR)/$(OPENSWAN_SOURCE):
	 $(WGET) -P $(DL_DIR) $(OPENSWAN_SITE)/$(OPENSWAN_SOURCE)

openswan-source: $(DL_DIR)/$(OPENSWAN_SOURCE)

$(OPENSWAN_DIR)/.unpacked: $(DL_DIR)/$(OPENSWAN_SOURCE)
	$(OPENSWAN_CAT) $(DL_DIR)/$(OPENSWAN_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(OPENSWAN_DIR) package/openswan/ openswan\*.patch
	touch $(OPENSWAN_DIR)/.unpacked

$(OPENSWAN_DIR)/$(OPENSWAN_BINARY): $(OPENSWAN_DIR)/.unpacked
	@echo "using kernel $(LINUX_KERNEL)"
	$(TARGET_CONFIGURE_OPTS) \
	$(MAKE) -C $(OPENSWAN_DIR) \
		CC=$(TARGET_CC) LD=$(TARGET_LD) \
		KERNELSRC=$(LINUX_DIR) DESTDIR=$(TARGET_DIR) INC_USRLOCAL=/usr \
		USERCOMPILE="$(OPENSWAN_CFLAGS) $(TARGET_CFLAGS) -I$(TARGET_DIR)/usr/include" programs

$(TARGET_DIR)/$(OPENSWAN_TARGET_BINARY): $(OPENSWAN_DIR)/$(OPENSWAN_BINARY)
	$(TARGET_CONFIGURE_OPTS) \
	$(MAKE) -C $(OPENSWAN_DIR) \
		CC=$(TARGET_CC) LD=$(TARGET_LD) \
		KERNELSRC=$(LINUX_DIR) DESTDIR=$(TARGET_DIR) INC_USRLOCAL=/usr \
		USERCOMPILE="$(OPENSWAN_CFLAGS) $(TARGET_CFLAGS) -I$(TARGET_DIR)/usr/include" install
	rm -rf $(TARGET_DIR)/share/locale $(TARGET_DIR)/usr/info \
		$(TARGET_DIR)/usr/man $(TARGET_DIR)/usr/share/doc

openswan: uclibc libgmp kernel-headers $(TARGET_DIR)/$(OPENSWAN_TARGET_BINARY)

openswan-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) -C $(OPENSWAN_DIR) uninstall
	-$(MAKE) -C $(OPENSWAN_DIR) clean

openswan-dirclean:
	rm -rf $(OPENSWAN_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_OPENSWAN)),y)
TARGETS+=openswan
endif
