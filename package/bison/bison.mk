#############################################################
#
# bison
#
#############################################################
BISON_VERSION:=2.3
BISON_SOURCE:=bison-$(BISON_VERSION).tar.bz2
BISON_SITE:=http://ftp.gnu.org/pub/gnu/bison
BISON_DIR:=$(BUILD_DIR)/bison-$(BISON_VERSION)
BISON_CAT:=$(BZCAT)
BISON_BINARY:=src/bison
BISON_TARGET_BINARY:=usr/bin/bison

$(DL_DIR)/$(BISON_SOURCE):
	 $(WGET) -P $(DL_DIR) $(BISON_SITE)/$(BISON_SOURCE)

bison-source: $(DL_DIR)/$(BISON_SOURCE)

$(BISON_DIR)/.unpacked: $(DL_DIR)/$(BISON_SOURCE)
	$(BISON_CAT) $(DL_DIR)/$(BISON_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	$(CONFIG_UPDATE) $(BISON_DIR)/build-aux
	touch $(BISON_DIR)/.unpacked

$(BISON_DIR)/.configured: $(BISON_DIR)/.unpacked
	(cd $(BISON_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		gt_cv_func_gnugettext2_libintl=yes \
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
		$(DISABLE_NLS) \
	);
	echo 'all install:' > $(BISON_DIR)/examples/Makefile
	touch $(BISON_DIR)/.configured

$(BISON_DIR)/$(BISON_BINARY): $(BISON_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(BISON_DIR)

$(TARGET_DIR)/$(BISON_TARGET_BINARY): $(BISON_DIR)/$(BISON_BINARY)
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(BISON_DIR) install
	rm -rf $(TARGET_DIR)/share/locale $(TARGET_DIR)/usr/info \
		$(TARGET_DIR)/usr/man $(TARGET_DIR)/usr/share/doc
	cp -a package/bison/yacc $(TARGET_DIR)/usr/bin/yacc

bison: uclibc $(TARGET_DIR)/$(BISON_TARGET_BINARY)

bison-clean:
	-$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(BISON_DIR) uninstall
	rm -f $(TARGET_DIR)/$(BISON_TARGET_BINARY)
	-$(MAKE) -C $(BISON_DIR) clean

bison-dirclean:
	rm -rf $(BISON_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_BISON)),y)
TARGETS+=bison
endif
