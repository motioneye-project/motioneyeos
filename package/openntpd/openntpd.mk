#############################################################
#
# OpenNTPD
#
#############################################################
OPENNTPD_VERSION:=3.6.1p1
OPENNTPD_SOURCE:=openntpd-$(OPENNTPD_VERSION).tar.gz
OPENNTPD_SITE:=ftp://ftp.openbsd.org/pub/OpenBSD/OpenNTPD
OPENNTPD_DIR:=$(BUILD_DIR)/openntpd-$(OPENNTPD_VERSION)
OPENNTPD_CAT:=$(ZCAT)
OPENNTPD_BINARY:=ntpd
OPENNTPD_TARGET_BINARY:=usr/sbin/foo

$(DL_DIR)/$(OPENNTPD_SOURCE):
	$(WGET) -P $(DL_DIR) $(OPENNTPD_SITE)/$(OPENNTPD_SOURCE)

$(OPENNTPD_DIR)/.source: $(DL_DIR)/$(OPENNTPD_SOURCE)
	$(ZCAT) $(DL_DIR)/$(OPENNTPD_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(OPENNTPD_DIR)/.source

$(OPENNTPD_DIR)/.configured: $(OPENNTPD_DIR)/.source
	(cd $(OPENNTPD_DIR); \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--sysconfdir=/etc \
		--with-builtin-arc4random \
	);
	touch $(OPENNTPD_DIR)/.configured;

$(OPENNTPD_DIR)/$(OPENNTPD_BINARY): $(OPENNTPD_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(OPENNTPD_DIR)

$(TARGET_DIR)/$(OPENNTPD_TARGET_BINARY): $(OPENNTPD_DIR)/$(OPENNTPD_BINARY)
	$(MAKE) DESTDIR=$(TARGET_DIR) STRIP_OPT="" -C $(OPENNTPD_DIR) install
	-$(STRIP) $(TARGET_DIR)/usr/sbin/ntpd
	cp $(OPENNTPD_DIR)/ntpd.conf $(TARGET_DIR)/etc
	rm -Rf $(TARGET_DIR)/usr/man

ntpd: uclibc $(TARGET_DIR)/$(OPENNTPD_TARGET_BINARY)

ntpd-source: $(DL_DIR)/$(OPENNTPD_SOURCE)

ntpd-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) -C $(OPENNTPD_DIR) uninstall
	rm -f $(TARGET_DIR)/etc/ntpd.conf
	-$(MAKE) -C $(OPENNTPD_DIR) clean

ntpd-dirclean:
	rm -rf $(OPENNTPD_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_OPENNTPD)),y)
TARGETS+=ntpd
endif

