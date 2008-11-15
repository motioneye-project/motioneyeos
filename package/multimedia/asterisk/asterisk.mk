#############################################################
#
# asterisk
#
##############################################################
ASTERISK_VERSION:=1.6.0-beta6
ASTERISK_SOURCE:=asterisk-$(ASTERISK_VERSION).tar.gz
ASTERISK_SITE:=http://downloads.digium.com/pub/asterisk/old-releases
ASTERISK_DIR:=$(BUILD_DIR)/asterisk-$(ASTERISK_VERSION)
ASTERISK_BINARY:=asterisk
ASTERISK_TARGET_BINARY:=usr/sbin/asterisk

$(DL_DIR)/$(ASTERISK_SOURCE):
	$(WGET) -P $(DL_DIR) $(ASTERISK_SITE)/$(ASTERISK_SOURCE)

$(ASTERISK_DIR)/.source: $(DL_DIR)/$(ASTERISK_SOURCE)
	$(ZCAT) $(DL_DIR)/$(ASTERISK_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(ASTERISK_DIR) package/multimedia/asterisk/ asterisk\*.patch
	touch $@

$(ASTERISK_DIR)/.configured: $(ASTERISK_DIR)/.source
	touch $@

$(ASTERISK_DIR)/$(ASTERISK_BINARY): $(ASTERISK_DIR)/.configured
	$(MAKE1) -C $(ASTERISK_DIR) \
		CROSS_ARCH=Linux \
		CROSS_COMPILE=$(TARGET_CROSS) \
		CROSS_COMPILE_BIN=$(STAGING_DIR)/bin/ \
		CROSS_COMPILE_TARGET=$(STAGING_DIR) \
		CROSS_PROC=$(OPTIMIZE_FOR_CPU) \
		OPTIMIZE="$(TARGET_OPTIMIZATION)" \
		OPTIONS=-DLOW_MEMORY \
		DEBUG= \
		$(TARGET_CONFIGURE_OPTS)

$(TARGET_DIR)/$(ASTERISK_TARGET_BINARY): $(ASTERISK_DIR)/$(ASTERISK_BINARY)
	$(MAKE) -C $(ASTERISK_DIR) \
		CROSS_ARCH=Linux \
		CROSS_COMPILE=$(TARGET_CROSS) \
		CROSS_COMPILE_BIN=$(TARGET_CC) \
		CROSS_COMPILE_TARGET=$(STAGING_DIR) \
		CROSS_PROC=$(OPTIMIZE_FOR_CPU) \
		OPTIMIZE="$(TARGET_OPTIMIZATION)" \
		OPTIONS=-DLOW_MEMORY \
		DEBUG= \
		$(TARGET_CONFIGURE_OPTS) \
		DESTDIR=$(TARGET_DIR) install
	$(STRIPCMD) $(TARGET_DIR)/usr/sbin/asterisk
	$(STRIPCMD) $(TARGET_DIR)/usr/sbin/stereorize
	$(STRIPCMD) $(TARGET_DIR)/usr/sbin/streamplayer
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) \
		$(TARGET_DIR)/usr/lib/asterisk/modules/*.so
	$(INSTALL) -m 755 $(ASTERISK_DIR)/contrib/init.d/rc.debian.asterisk \
		$(TARGET_DIR)/etc/init.d/S60asterisk
	mv $(TARGET_DIR)/usr/include/asterisk $(STAGING_DIR)/usr/include/
ifneq ($(BR2_HAVE_MANPAGES),y)
	rm -Rf $(TARGET_DIR)/usr/share/man
endif
	rm -f $(TARGET_DIR)/usr/sbin/safe_asterisk
	rm -f $(TARGET_DIR)/usr/sbin/autosupport
	rm -f $(TARGET_DIR)/usr/sbin/astgenkey
	touch -c $@

asterisk: uclibc ncurses zlib openssl mpg123 $(TARGET_DIR)/$(ASTERISK_TARGET_BINARY)

asterisk-source: $(DL_DIR)/$(ASTERISK_SOURCE)

asterisk-clean:
	rm -Rf $(STAGING_DIR)/usr/include/asterisk
	rm -Rf $(TARGET_DIR)/etc/asterisk
	rm -Rf $(TARGET_DIR)/usr/lib/asterisk
	rm -Rf $(TARGET_DIR)/var/lib/asterisk
	rm -Rf $(TARGET_DIR)/var/spool/asterisk
	rm -f $(TARGET_DIR)/etc/init.d/S60asterisk
	rm -f $(TARGET_DIR)/usr/sbin/stereorize
	rm -f $(TARGET_DIR)/usr/sbin/streamplayer
	-$(MAKE) -C $(ASTERISK_DIR) clean

asterisk-dirclean:
	rm -rf $(ASTERISK_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_ASTERISK)),y)
TARGETS+=asterisk
endif
