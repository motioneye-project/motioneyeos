#############################################################
#
# distcc
#
#############################################################
DISTCC_VER:=2.17
DISTCC_SOURCE:=distcc-$(DISTCC_VER).tar.bz2
DISTCC_SITE:=http://distcc.samba.org/ftp/distcc/
DISTCC_DIR:=$(BUILD_DIR)/distcc-$(DISTCC_VER)
DISTCC_BINARY:=distcc
DISTCC_TARGET_BINARY:=usr/bin/distcc

$(DL_DIR)/$(DISTCC_SOURCE):
	$(WGET) -P $(DL_DIR) $(DISTCC_SITE)/$(DISTCC_SOURCE)

$(DISTCC_DIR)/.unpacked: $(DL_DIR)/$(DISTCC_SOURCE)
	bzcat $(DL_DIR)/$(DISTCC_SOURCE) | tar -C $(BUILD_DIR) -x$(TAR_VERBOSITY)f -
	touch $(DISTCC_DIR)/.unpacked

$(DISTCC_DIR)/.configured: $(DISTCC_DIR)/.unpacked
	(cd $(DISTCC_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) CC_FOR_BUILD=$(HOSTCC) \
		CFLAGS="$(TARGET_CFLAGS)" \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--mandir=/usr/man \
		--infodir=/usr/info \
		--with-included-popt \
		--without-gtk \
		--without-gnome \
	);
	touch $(DISTCC_DIR)/.configured

$(DISTCC_DIR)/$(DISTCC_BINARY): $(DISTCC_DIR)/.configured
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CC=$(TARGET_CC) -C $(DISTCC_DIR)

$(TARGET_DIR)/$(DISTCC_TARGET_BINARY): $(DISTCC_DIR)/$(DISTCC_BINARY)
	install -D $(DISTCC_DIR)/$(DISTCC_BINARY)d $(TARGET_DIR)/$(DISTCC_TARGET_BINARY)d
	install -D $(DISTCC_DIR)/$(DISTCC_BINARY) $(TARGET_DIR)/$(DISTCC_TARGET_BINARY)

distcc: uclibc $(TARGET_DIR)/$(DISTCC_TARGET_BINARY)

distcc-clean:
	rm -f $(TARGET_DIR)/$(DISTCC_TARGET_BINARY)
	rm -f $(TARGET_DIR)/$(DISTCC_TARGET_BINARY)d
	-$(MAKE) -C $(DISTCC_DIR) clean

distcc-dirclean:
	rm -rf $(DISTCC_DIR)
