#############################################################
#
# util-linux
#
#############################################################
UTIL-LINUX_SOURCE:=util-linux-2.11z.tar.gz
UTIL-LINUX_SITE:=http://www.kernel.org/pub/linux/utils/util-linux
UTIL-LINUX_CAT:=zcat
UTIL-LINUX_DIR:=$(BUILD_DIR)/util-linux-2.11z
UTIL-LINUX_BINARY:=$(UTIL-LINUX_DIR)/misc-utils/mcookie
UTIL-LINUX_TARGET_BINARY:=$(TARGET_DIR)/usr/bin/mcookie

$(DL_DIR)/$(UTIL-LINUX_SOURCE):
	  $(WGET) -P $(DL_DIR) $(UTIL-LINUX_SITE)/$(UTIL-LINUX_SOURCE)

$(UTIL-LINUX_DIR)/.unpacked: $(DL_DIR)/$(UTIL-LINUX_SOURCE)
	$(UTIL-LINUX_CAT) $(DL_DIR)/$(UTIL-LINUX_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	touch $(UTIL-LINUX_DIR)/.unpacked

$(UTIL-LINUX_DIR)/.configured: $(UTIL-LINUX_DIR)/.unpacked
	(cd $(UTIL-LINUX_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
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
	);
	perl -pi -e "s,^INSTALLSUID=.*,INSTALLSUID=\\$$\(INSTALL\) -m \\$$\(BINMODE\)," \
		$(UTIL-LINUX_DIR)/MCONFIG
	perl -pi -e "s,^USE_TTY_GROUP=.*,USE_TTY_GROUP=no," $(UTIL-LINUX_DIR)/MCONFIG
	touch $(UTIL-LINUX_DIR)/.configured

$(UTIL-LINUX_BINARY): $(UTIL-LINUX_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(UTIL-LINUX_DIR)

$(UTIL-LINUX_TARGET_BINARY): $(UTIL-LINUX_BINARY)
	$(MAKE) DESTDIR=$(TARGET_DIR) USE_TTY_GROUP=no -C $(UTIL-LINUX_DIR) install
	rm -rf $(TARGET_DIR)/share/locale $(TARGET_DIR)/usr/info \
		$(TARGET_DIR)/usr/man $(TARGET_DIR)/usr/share/doc

util-linux: uclibc $(UTIL-LINUX_TARGET_BINARY)

util-linux-clean:
	#There is no working 'uninstall' target.  Just skip it... 
	#$(MAKE) DESTDIR=$(TARGET_DIR) -C $(UTIL-LINUX_DIR) uninstall
	-$(MAKE) -C $(UTIL-LINUX_DIR) clean

util-linux-dirclean:
	rm -rf $(UTIL-LINUX_DIR)


