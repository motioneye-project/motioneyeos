#############################################################
#
# kismet
#
#############################################################
KISMET_VERSION:=2007-10-R1
KISMET_SOURCE:=kismet-$(KISMET_VERSION).tar.gz
KISMET_SITE:=http://www.kismetwireless.net/code/
KISMET_DIR:=$(BUILD_DIR)/kismet-$(KISMET_VERSION)
KISMET_CAT:=$(ZCAT)
KISMET_BINARY:=kismet
KISMET_TARGET_DIRECTORY=usr/bin/

$(DL_DIR)/$(KISMET_SOURCE):
	$(WGET) -P $(DL_DIR) $(KISMET_SITE)/$(KISMET_SOURCE)

kismet-source: $(DL_DIR)/$(KISMET_SOURCE)

$(KISMET_DIR)/.patched: $(DL_DIR)/$(KISMET_SOURCE)
	$(KISMET_CAT) $(DL_DIR)/$(KISMET_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(KISMET_DIR) package/kismet/ kismet\*.patch
	touch $@

$(KISMET_DIR)/.configured: $(KISMET_DIR)/.patched
	(cd $(KISMET_DIR); rm -rf config.cache; \
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
	)
	touch $@

$(KISMET_DIR)/$(KISMET_BINARY): $(KISMET_DIR)/.configured
	$(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" \
		-C $(KISMET_DIR)

$(TARGET_DIR)/$(KISMET_TARGET_DIRECTORY)/$(KISMET_BINARY): $(KISMET_DIR)/$(KISMET_BINARY)
	install -m 755 $(KISMET_DIR)/kismet $(TARGET_DIR)/$(KISMET_TARGET_DIRECTORY)/kismet
	install -m 755 $(KISMET_DIR)/kismet_client $(TARGET_DIR)/$(KISMET_TARGET_DIRECTORY)/kismet_client
	install -m 755 $(KISMET_DIR)/kismet_drone $(TARGET_DIR)/$(KISMET_TARGET_DIRECTORY)/kismet_drone
	install -m 755 $(KISMET_DIR)/kismet_server $(TARGET_DIR)/$(KISMET_TARGET_DIRECTORY)/kismet_server
	install -m 755 $(KISMET_DIR)/conf/kismet.conf $(TARGET_DIR)/etc/kismet.conf

kismet: uclibc ncurses libpcap $(TARGET_DIR)/$(KISMET_TARGET_DIRECTORY)/$(KISMET_BINARY)


kismet-clean:
	rm -f $(TARGET_DIR)/$(KISMET_TARGET_DIRECTORY)/kismet
	rm -f $(TARGET_DIR)/$(KISMET_TARGET_DIRECTORY)/kismet_client
	rm -f $(TARGET_DIR)/$(KISMET_TARGET_DIRECTORY)/kismet_drone
	rm -f $(TARGET_DIR)/$(KISMET_TARGET_DIRECTORY)/kismet_server
	rm -f $(KISMET_DIR)/conf/kismet.conf $(TARGET_DIR)/etc/kismet.conf
	-$(MAKE) -C $(KISMET_DIR) clean

kismet-dirclean:
	rm -rf $(KISMET_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_KISMET)),y)
TARGETS+=kismet
endif
