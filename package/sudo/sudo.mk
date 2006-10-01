#############################################################
#
# sudo
#
#############################################################

SUDO_VER:=1.6.8p9
SUDO_DIR:=$(BUILD_DIR)/sudo-$(SUDO_VER)
SUDO_SOURCE:=sudo-$(SUDO_VER).tar.gz
SUDO_SITE=http://www.courtesan.com/sudo/dist
SUDO_UNZIP=$(ZCAT)

$(DL_DIR)/$(SUDO_SOURCE):
	 $(WGET) -P $(DL_DIR) $(SUDO_SITE)/$(SUDO_SOURCE)

sudo-source: $(DL_DIR)/$(SUDO_SOURCE) $(SUDO_CONFIG_FILE)

$(SUDO_DIR)/.unpacked: $(DL_DIR)/$(SUDO_SOURCE)
	$(SUDO_UNZIP) $(DL_DIR)/$(SUDO_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	# Allow sudo patches.
	toolchain/patch-kernel.sh $(SUDO_DIR) package/sudo sudo\*.patch
	touch $(SUDO_DIR)/.unpacked

$(SUDO_DIR)/.configured: $(SUDO_DIR)/.unpacked $(SUDO_CONFIG_FILE)
	(cd $(SUDO_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
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
		$(DISABLE_LARGEFILE) \
		--without-lecture \
		--without-sendmail \
		--without-umask \
		--with-logging=syslog \
		--without-interfaces \
		--disable-authentication \
		$(SUDO_EXTRA_CONFIG) \
	);

	touch $(SUDO_DIR)/.configured

$(SUDO_DIR)/sudo: $(SUDO_DIR)/.configured
	$(MAKE) -C $(SUDO_DIR)
	touch -c $(SUDO_DIR)/sudo

$(TARGET_DIR)/usr/bin/sudo: $(SUDO_DIR)/sudo
	# Use fakeroot to pretend to do 'make install' as root
	echo "$(MAKE) $(TARGET_CONFIGURE_OPTS) DESTDIR="$(TARGET_DIR)" -C $(SUDO_DIR) install" \
		> $(STAGING_DIR)/.fakeroot.sudo
	touch -c $(TARGET_DIR)/usr/bin/sudo

sudo: uclibc $(TARGET_DIR)/usr/bin/sudo

sudo-clean:
	rm -f $(TARGET_DIR)/usr/bin/sudo
	-$(MAKE) -C $(SUDO_DIR) clean

sudo-dirclean:
	rm -rf $(SUDO_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_SUDO)),y)
TARGETS+=sudo
endif

ifeq ($(strip $(BR2_PACKAGE_LIBPAM)),y)
SUDO_EXTRA_CONFIG=--enable-pam
sudo: libpam
endif
