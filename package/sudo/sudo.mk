#############################################################
#
# sudo
#
#############################################################

SUDO_VERSION:=1.6.8p12
SUDO_SITE:=$(BR2_DEBIAN_MIRROR)/debian/pool/main/s/sudo
SUDO_SOURCE:=sudo_$(SUDO_VERSION).orig.tar.gz

#SUDO_VERSION:=1.7.0
#SUDO_SITE:=http://www.courtesan.com/sudo/dist
# 1.7.0 Needs update Cross-Compiler patches
# SUDO_SOURCE:=sudo-$(SUDO_VERSION).tar.gz

SUDO_DIR:=$(BUILD_DIR)/sudo-$(SUDO_VERSION)
SUDO_UNZIP:=$(ZCAT)

$(DL_DIR)/$(SUDO_SOURCE):
	 $(call DOWNLOAD,$(SUDO_SITE),$(SUDO_SOURCE))

sudo-source: $(DL_DIR)/$(SUDO_SOURCE) $(SUDO_CONFIG_FILE)

$(SUDO_DIR)/.unpacked: $(DL_DIR)/$(SUDO_SOURCE)
	$(SUDO_UNZIP) $(DL_DIR)/$(SUDO_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(SUDO_DIR) package/sudo sudo-$(SUDO_VERSION)\*.patch
	$(CONFIG_UPDATE) $(SUDO_DIR)
	touch $@

$(SUDO_DIR)/.configured: $(SUDO_DIR)/.unpacked $(SUDO_CONFIG_FILE)
	(cd $(SUDO_DIR); rm -rf config.cache; \
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
		$(DISABLE_LARGEFILE) \
		--without-lecture \
		--without-sendmail \
		--without-umask \
		--with-logging=syslog \
		--without-interfaces \
		--disable-authentication \
		$(SUDO_EXTRA_CONFIG) \
	)

	touch $@

$(SUDO_DIR)/sudo: $(SUDO_DIR)/.configured
	$(MAKE) -C $(SUDO_DIR)
	touch -c $@

$(TARGET_DIR)/usr/bin/sudo: $(SUDO_DIR)/sudo
	rm -f $(TARGET_DIR)/usr/bin/sudo
	rm -f $(TARGET_DIR)/usr/sbin/visudo
	rm -f $(TARGET_DIR)/etc/sudoers
	$(INSTALL) -m 0777 -D $(SUDO_DIR)/sudo $(TARGET_DIR)/usr/bin/sudo
	$(INSTALL) -m 0777 -D $(SUDO_DIR)/visudo $(TARGET_DIR)/usr/sbin/visudo
	$(STRIPCMD) $(TARGET_DIR)/usr/bin/sudo $(TARGET_DIR)/usr/sbin/visudo
	chmod 4555  $(TARGET_DIR)/usr/bin/sudo
	chmod 0555  $(TARGET_DIR)/usr/sbin/visudo
	$(INSTALL) -m 0440 -D $(SUDO_DIR)/sudoers $(TARGET_DIR)/etc/sudoers
	touch -c $(TARGET_DIR)/usr/bin/sudo

sudo: uclibc $(TARGET_DIR)/usr/bin/sudo

sudo-unpacked: $(SUDO_DIR)/.unpacked

sudo-clean:
	rm -f $(TARGET_DIR)/usr/bin/sudo $(TARGET_DIR)/etc/sudoers \
		$(TARGET_DIR)/usr/sbin/visudo
	-$(MAKE) -C $(SUDO_DIR) clean

sudo-dirclean:
	rm -rf $(SUDO_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_SUDO),y)
TARGETS+=sudo
endif

ifeq ($(BR2_PACKAGE_LIBPAM),y)
SUDO_EXTRA_CONFIG=--enable-pam
sudo: libpam
endif
