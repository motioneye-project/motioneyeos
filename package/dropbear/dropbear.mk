#############################################################
#
# dropbear
#
#############################################################
DROPBEAR_VER:=0.48
DROPBEAR_SOURCE:=dropbear-$(DROPBEAR_VER).tar.bz2
DROPBEAR_SITE:=http://matt.ucc.asn.au/dropbear/releases/
DROPBEAR_DIR:=$(BUILD_DIR)/dropbear-$(DROPBEAR_VER)
DROPBEAR_CAT:=bzcat
DROPBEAR_BINARY:=dropbearmulti
DROPBEAR_TARGET_BINARY:=usr/sbin/dropbear

$(DL_DIR)/$(DROPBEAR_SOURCE):
	 $(WGET) -P $(DL_DIR) $(DROPBEAR_SITE)/$(DROPBEAR_SOURCE)

dropbear-source: $(DL_DIR)/$(DROPBEAR_SOURCE)

$(DROPBEAR_DIR)/.unpacked: $(DL_DIR)/$(DROPBEAR_SOURCE)
	$(DROPBEAR_CAT) $(DL_DIR)/$(DROPBEAR_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(DROPBEAR_DIR) package/dropbear/ dropbear\*.patch
	$(SED) 's,^/\* #define DROPBEAR_MULTI.*,#define DROPBEAR_MULTI,g' $(DROPBEAR_DIR)/options.h
	touch $(DROPBEAR_DIR)/.unpacked

$(DROPBEAR_DIR)/.configured: $(DROPBEAR_DIR)/.unpacked
	(cd $(DROPBEAR_DIR); rm -rf config.cache; \
		autoconf; \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--mandir=/usr/man \
		--infodir=/usr/info \
		$(DISABLE_NLS) \
		--with-shared \
	);
ifeq ($(strip $(BR2_PACKAGE_DROPBEAR_URANDOM)),y)
	$(SED) 's,^#define DROPBEAR_RANDOM_DEV.*,#define DROPBEAR_RANDOM_DEV \"/dev/urandom\",' \
		$(DROPBEAR_DIR)/options.h
endif
	touch $(DROPBEAR_DIR)/.configured

$(DROPBEAR_DIR)/$(DROPBEAR_BINARY): $(DROPBEAR_DIR)/.configured
	$(MAKE) $(TARGET_CONFIGURE_OPTS) LD=$(TARGET_CC) \
		PROGRAMS="dropbear dbclient dropbearkey dropbearconvert scp" \
		MULTI=1 SCPPROGRESS=1 -C $(DROPBEAR_DIR)

$(TARGET_DIR)/$(DROPBEAR_TARGET_BINARY): $(DROPBEAR_DIR)/$(DROPBEAR_BINARY)
	#$(MAKE) DESTDIR=$(TARGET_DIR) $(TARGET_CONFIGURE_OPTS) \
	#	LD=$(TARGET_CC) -C $(DROPBEAR_DIR) install
	#rm -rf $(TARGET_DIR)/share/locale $(TARGET_DIR)/usr/info \
	#	$(TARGET_DIR)/usr/man $(TARGET_DIR)/usr/share/doc
	install -d -m 755 $(TARGET_DIR)/usr/sbin
	install -d -m 755 $(TARGET_DIR)/usr/bin
	install -m 755 $(DROPBEAR_DIR)/$(DROPBEAR_BINARY) \
		$(TARGET_DIR)/$(DROPBEAR_TARGET_BINARY)
	$(STRIP) $(TARGET_DIR)/$(DROPBEAR_TARGET_BINARY)
	ln -snf ../sbin/dropbear $(TARGET_DIR)/usr/bin/scp
	ln -snf ../sbin/dropbear $(TARGET_DIR)/usr/bin/ssh
	ln -snf ../sbin/dropbear $(TARGET_DIR)/usr/bin/dbclient
	ln -snf ../sbin/dropbear $(TARGET_DIR)/usr/bin/dropbearkey
	ln -snf ../sbin/dropbear $(TARGET_DIR)/usr/bin/dropbearconvert
	cp $(DROPBEAR_DIR)/S50dropbear $(TARGET_DIR)/etc/init.d/
	chmod a+x $(TARGET_DIR)/etc/init.d/S50dropbear

dropbear: uclibc zlib $(TARGET_DIR)/$(DROPBEAR_TARGET_BINARY)

dropbear-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) $(TARGET_CONFIGURE_OPTS) \
		LD=$(TARGET_CC) -C $(DROPBEAR_DIR) uninstall
	-$(MAKE) -C $(DROPBEAR_DIR) clean

dropbear-dirclean:
	rm -rf $(DROPBEAR_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_DROPBEAR)),y)
TARGETS+=dropbear
endif
