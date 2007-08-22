#############################################################
#
# lighttpd
#
#############################################################
LIGHTTPD_VERSION:=1.4.16
LIGHTTPD_SOURCE:=lighttpd_$(LIGHTTPD_VERSION).orig.tar.gz
LIGHTTPD_PATCH:=lighttpd_$(LIGHTTPD_VERSION)-1.diff.gz
LIGHTTPD_SITE:=http://ftp.debian.org/debian/pool/main/l/lighttpd
LIGHTTPD_DIR:=$(BUILD_DIR)/lighttpd-$(LIGHTTPD_VERSION)
LIGHTTPD_CAT:=$(ZCAT)
LIGHTTPD_BINARY:=src/lighttpd
LIGHTTPD_TARGET_BINARY:=usr/sbin/lighttpd

$(DL_DIR)/$(LIGHTTPD_SOURCE):
	$(WGET) -P $(DL_DIR) $(LIGHTTPD_SITE)/$(LIGHTTPD_SOURCE)
ifneq ($(LIGHTTPD_PATCH),)
LIGHTTPD_PATCH_FILE:=$(DL_DIR)/$(LIGHTTPD_PATCH)
$(LIGHTTPD_PATCH_FILE):
	$(WGET) -P $(DL_DIR) $(LIGHTTPD_SITE)/$(LIGHTTPD_PATCH)
endif
lighttpd-source: $(DL_DIR)/$(LIGHTTPD_SOURCE) $(LIGHTTPD_PATCH_FILE)

$(LIGHTTPD_DIR)/.unpacked: $(DL_DIR)/$(LIGHTTPD_SOURCE)
	$(LIGHTTPD_CAT) $(DL_DIR)/$(LIGHTTPD_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(LIGHTTPD_DIR) package/lighttpd/ lighttpd\*.patch
ifneq ($(LIGHTTPD_PATCH),)
	(cd $(LIGHTTPD_DIR)&&$(LIGHTTPD_CAT) $(LIGHTTPD_PATCH_FILE)|patch -p1)
endif
	if [ -d $(LIGHTTPD_DIR)/debian/patches ]; then \
		toolchain/patch-kernel.sh $(LIGHTTPD_DIR) $(LIGHTTPD_DIR)/debian/patches \*.dpatch; \
	fi
	$(CONFIG_UPDATE) $(@D)
	$(SED) 's/-lfs/-largefile/g;s/_lfs/_largefile/g' $(LIGHTTPD_DIR)/configure
	touch $@

ifeq ($(strip $(BR2_PACKAGE_LIGHTTPD_OPENSSL)),y)
LIGHTTPD_OPENSSL:=--with-openssl
else
LIGHTTPD_OPENSSL:=--without-openssl
endif

$(LIGHTTPD_DIR)/.configured: $(LIGHTTPD_DIR)/.unpacked
	(cd $(LIGHTTPD_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--libdir=/usr/lib/lighttpd \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--localstatedir=/var \
		$(LIGHTTPD_OPENSSL) \
		--without-pcre \
		--program-prefix="" \
		$(DISABLE_IPV6) \
		$(DISABLE_LARGEFILE) \
	)
	touch $@

$(LIGHTTPD_DIR)/$(LIGHTTPD_BINARY): $(LIGHTTPD_DIR)/.configured
	$(MAKE) -C $(LIGHTTPD_DIR)
   
$(TARGET_DIR)/$(LIGHTTPD_TARGET_BINARY): $(LIGHTTPD_DIR)/$(LIGHTTPD_BINARY)
	$(MAKE) DESTDIR=$(TARGET_DIR) -C $(LIGHTTPD_DIR) install
	@rm -rf $(TARGET_DIR)/usr/share/man $(TARGET_DIR)/usr/man
	@rm -rf $(TARGET_DIR)/usr/lib/lighttpd/*.la
	$(STRIP) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/lighttpd/*.so
	$(STRIP) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/$(LIGHTTPD_TARGET_BINARY)
	@if [ ! -f $(TARGET_DIR)/etc/lighttpd/lighttpd.conf ]; then \
		$(INSTALL) -m 0644 -D $(LIGHTTPD_DIR)/doc/lighttpd.conf $(TARGET_DIR)/etc/lighttpd/lighttpd.conf; \
	fi
	$(INSTALL) -m 0755 -D package/lighttpd/rc.lighttpd $(TARGET_DIR)/etc/init.d/S99lighttpd

ifeq ($(strip $(BR2_PACKAGE_LIGHTTPD_OPENSSL)),y)
lighttpd: uclibc openssl $(TARGET_DIR)/$(LIGHTTPD_TARGET_BINARY)
else
lighttpd: uclibc $(TARGET_DIR)/$(LIGHTTPD_TARGET_BINARY)
endif

lighttpd-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(LIGHTTPD_DIR) uninstall
	@rm -rf $(TARGET_DIR)/usr/lib/lighttpd
	@rm -f $(TARGET_DIR)/etc/init.d/S99lighttpd
	@rm -f $(TARGET_DIR)/etc/lighttpd/lighttpd.conf
	@rmdir -p --ignore-fail-on-non-empty $(TARGET_DIR)/etc/lighttpd
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
