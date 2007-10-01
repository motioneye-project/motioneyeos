#############################################################
#
# openssh
#
#############################################################
OPENSSH_VERSION=4.6p1
OPENSSH_SITE=ftp://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable
OPENSSH_DIR=$(BUILD_DIR)/openssh-$(OPENSSH_VERSION)
OPENSSH_SOURCE=openssh-$(OPENSSH_VERSION).tar.gz

$(DL_DIR)/$(OPENSSH_SOURCE):
	$(WGET) -P $(DL_DIR) $(OPENSSH_SITE)/$(OPENSSH_SOURCE)

$(OPENSSH_DIR)/.unpacked: $(DL_DIR)/$(OPENSSH_SOURCE)
	$(ZCAT) $(DL_DIR)/$(OPENSSH_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(OPENSSH_DIR) package/openssh/ openssh\*.patch
	$(CONFIG_UPDATE) $(@D)
	touch $@

$(OPENSSH_DIR)/.configured: $(OPENSSH_DIR)/.unpacked
	(cd $(OPENSSH_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		LD=$(TARGET_CROSS)gcc \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libdir=/lib \
		--libexecdir=/usr/sbin \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--mandir=/usr/man \
		--infodir=/usr/info \
		--includedir=$(STAGING_DIR)/usr/include \
		--disable-lastlog --disable-utmp \
		--disable-utmpx --disable-wtmp --disable-wtmpx \
		--without-x \
		--disable-strip \
		$(DISABLE_NLS) \
		$(DISABLE_LARGEFILE) \
	)
	touch $@

$(OPENSSH_DIR)/ssh: $(OPENSSH_DIR)/.configured
	$(MAKE) -C $(OPENSSH_DIR)
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(OPENSSH_DIR)/scp
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(OPENSSH_DIR)/sftp
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(OPENSSH_DIR)/sftp-server
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(OPENSSH_DIR)/ssh
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(OPENSSH_DIR)/ssh-add
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(OPENSSH_DIR)/ssh-agent
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(OPENSSH_DIR)/ssh-keygen
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(OPENSSH_DIR)/ssh-keyscan
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(OPENSSH_DIR)/ssh-keysign
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(OPENSSH_DIR)/ssh-rand-helper
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(OPENSSH_DIR)/sshd

$(TARGET_DIR)/usr/bin/ssh: $(OPENSSH_DIR)/ssh
	$(MAKE) DESTDIR=$(TARGET_DIR) -C $(OPENSSH_DIR) install
	mkdir -p $(TARGET_DIR)/etc/init.d
	cp package/openssh/S50sshd $(TARGET_DIR)/etc/init.d/
	chmod a+x $(TARGET_DIR)/etc/init.d/S50sshd
	rm -rf $(TARGET_DIR)/usr/info $(TARGET_DIR)/usr/man $(TARGET_DIR)/usr/share/doc

openssh: openssl zlib $(TARGET_DIR)/usr/bin/ssh

openssh-source: $(DL_DIR)/$(OPENSSH_SOURCE)

openssh-clean:
	$(MAKE) -C $(OPENSSH_DIR) clean
	$(MAKE) CC=$(TARGET_CC) DESTDIR=$(TARGET_DIR) -C $(OPENSSH_DIR) uninstall

openssh-dirclean:
	rm -rf $(OPENSSH_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_OPENSSH)),y)
TARGETS+=openssh
endif
