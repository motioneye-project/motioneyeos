#############################################################
#
# util-linux
#
#############################################################
UTIL-LINUX_VERSION:=2.12r
UTIL-LINUX_SOURCE:=util-linux-$(UTIL-LINUX_VERSION).tar.bz2
UTIL-LINUX_SITE:=http://www.kernel.org/pub/linux/utils/util-linux
UTIL-LINUX_DIR:=$(BUILD_DIR)/util-linux-$(UTIL-LINUX_VERSION)
UTIL-LINUX_CAT:=$(BZCAT)
UTIL-LINUX_BINARY:=$(UTIL-LINUX_DIR)/misc-utils/chkdupexe
UTIL-LINUX_TARGET_BINARY:=$(TARGET_DIR)/usr/bin/chkdupexe

$(DL_DIR)/$(UTIL-LINUX_SOURCE):
	$(WGET) -P $(DL_DIR) $(UTIL-LINUX_SITE)/$(UTIL-LINUX_SOURCE)

$(UTIL-LINUX_DIR)/.unpacked: $(DL_DIR)/$(UTIL-LINUX_SOURCE)
	$(UTIL-LINUX_CAT) $(DL_DIR)/$(UTIL-LINUX_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(UTIL-LINUX_DIR) package/util-linux/ util-linux\*.patch
ifneq ($(BR2_LARGEFILE),y)
	$(SED) "/D_FILE_OFFSET_BITS/ d" $(UTIL-LINUX_DIR)/MCONFIG
endif
	touch $(UTIL-LINUX_DIR)/.unpacked

$(UTIL-LINUX_DIR)/.configured: $(UTIL-LINUX_DIR)/.unpacked
	(cd $(UTIL-LINUX_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
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
		$(DISABLE_LARGEFILE) \
		ARCH=$(ARCH) \
	)
	$(SED) "s,^INSTALLSUID=.*,INSTALLSUID=\\$$\(INSTALL\) -m \\$$\(BINMODE\)," \
		$(UTIL-LINUX_DIR)/MCONFIG
	$(SED) "s,^USE_TTY_GROUP=.*,USE_TTY_GROUP=no," $(UTIL-LINUX_DIR)/MCONFIG
	touch $(UTIL-LINUX_DIR)/.configured

$(UTIL-LINUX_BINARY): $(UTIL-LINUX_DIR)/.configured
	$(MAKE) \
		-C $(UTIL-LINUX_DIR) \
		ARCH=$(ARCH) \
		CC=$(TARGET_CC) \
		OPT="$(TARGET_CFLAGS)" \
		HAVE_SLANG="NO"

$(UTIL-LINUX_TARGET_BINARY): $(UTIL-LINUX_BINARY)
	$(MAKE) ARCH=$(ARCH) DESTDIR=$(TARGET_DIR) USE_TTY_GROUP=no -C $(UTIL-LINUX_DIR) install
	rm -rf $(TARGET_DIR)/share/locale $(TARGET_DIR)/usr/share/info \
		$(TARGET_DIR)/usr/share/man $(TARGET_DIR)/usr/share/doc

#If both util-linux and busybox are selected, make certain util-linux
#wins the fight over who gets to have their utils actually installed
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
util-linux: uclibc busybox $(UTIL-LINUX_TARGET_BINARY)
else
util-linux: uclibc $(UTIL-LINUX_TARGET_BINARY)
endif


util-linux-source: $(DL_DIR)/$(UTIL-LINUX_SOURCE)

util-linux-clean:
	#There is no working 'uninstall' target.  Just skip it... 
	#$(MAKE) DESTDIR=$(TARGET_DIR) -C $(UTIL-LINUX_DIR) uninstall
	-$(MAKE) -C $(UTIL-LINUX_DIR) clean

util-linux-dirclean:
	rm -rf $(UTIL-LINUX_DIR)


#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_UTIL-LINUX)),y)
TARGETS+=util-linux
endif
