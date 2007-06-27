#############################################################
#
# lighttpd
#
#############################################################
LIGHTTPD_VER:=1.4.13
LIGHTTPD_SOURCE:=lighttpd-$(LIGHTTPD_VER).tar.gz
LIGHTTPD_SITE:=http://www.lighttpd.net/download
LIGHTTPD_DIR:=$(BUILD_DIR)/lighttpd-$(LIGHTTPD_VER)
LIGHTTPD_CAT:=$(ZCAT)
LIGHTTPD_BINARY:=src/lighttpd
LIGHTTPD_TARGET_BINARY:=usr/sbin/lighttpd

$(DL_DIR)/$(LIGHTTPD_SOURCE):
	 $(WGET) -P $(DL_DIR) $(LIGHTTPD_SITE)/$(LIGHTTPD_SOURCE)

lighttpd-source: $(DL_DIR)/$(LIGHTTPD_SOURCE)

#############################################################
#
# build lighttpd for use on the target system
#
#############################################################
$(LIGHTTPD_DIR)/.unpacked: $(DL_DIR)/$(LIGHTTPD_SOURCE)
	$(LIGHTTPD_CAT) $(DL_DIR)/$(LIGHTTPD_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(LIGHTTPD_DIR) package/lighttpd/ lighttpd\*.patch
	touch  $(LIGHTTPD_DIR)/.unpacked

$(LIGHTTPD_DIR)/.configured: $(LIGHTTPD_DIR)/.unpacked
	(cd $(LIGHTTPD_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--libdir=/lib \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--localstatedir=/var \
		--with-openssl \
		--without-pcre \
		--program-prefix="" \
	);
	touch  $(LIGHTTPD_DIR)/.configured

$(LIGHTTPD_DIR)/$(LIGHTTPD_BINARY): $(LIGHTTPD_DIR)/.configured
	$(MAKE) -C $(LIGHTTPD_DIR)
    
$(TARGET_DIR)/$(LIGHTTPD_TARGET_BINARY): $(LIGHTTPD_DIR)/$(LIGHTTPD_BINARY)
	$(MAKE) DESTDIR=$(TARGET_DIR) -C $(LIGHTTPD_DIR) install
	$(INSTALL) -m 0755 -D $(LIGHTTPD_DIR)/debian/init.d $(TARGET_DIR)/etc/init.d/S99lighttpd

lighttpd: uclibc openssl $(TARGET_DIR)/$(LIGHTTPD_TARGET_BINARY)

lighttpd-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(LIGHTTPD_DIR) uninstall
	-$(MAKE) -C $(LIGHTTPD_DIR) clean

lighttpd-dirclean:
	rm -rf $(LIGHTTPD_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LIGHTTPD)),y)
TARGETS+=lighttpd
endif
