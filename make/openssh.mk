#############################################################
#
# openssh
#
#############################################################

OPENSSH_SITE:=ftp://ftp.tux.org/bsd/openbsd/OpenSSH/portable/
OPENSSH_DIR:=$(BUILD_DIR)/openssh-3.6.1p1
OPENSSH_SOURCE:=openssh-3.6.1p1.tar.gz
OPENSSH_PATCH:=$(SOURCE_DIR)/openssh.patch

$(DL_DIR)/$(OPENSSH_SOURCE):
	$(WGET) -P $(DL_DIR) $(OPENSSH_SITE)/$(OPENSSH_SOURCE)

$(OPENSSH_DIR)/.unpacked: $(DL_DIR)/$(OPENSSH_SOURCE) $(OPENSSH_PATCH)
	zcat $(DL_DIR)/$(OPENSSH_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	cat $(OPENSSH_PATCH) | patch -p1 -d $(OPENSSH_DIR)
	touch  $(OPENSSH_DIR)/.unpacked

$(OPENSSH_DIR)/.configured: $(OPENSSH_DIR)/.unpacked
	(cd $(OPENSSH_DIR); rm -rf config.cache; autoconf; \
		$(TARGET_CONFIGURE_OPTS) \
		LD=$(TARGET_CROSS)gcc \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libexecdir=/usr/sbin \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--mandir=/usr/man \
		--infodir=/usr/info \
		--disable-nls \
		--includedir=$(STAGING_DIR)/include \
		--disable-lastlog --disable-utmp \
		--disable-utmpx --disable-wtmp --disable-wtmpx \
		--disable-nls --without-x \
	);
	touch  $(OPENSSH_DIR)/.configured

$(OPENSSH_DIR)/ssh: $(OPENSSH_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(OPENSSH_DIR)
	-$(STRIP) --strip-unneeded $(OPENSSH_DIR)/scp
	-$(STRIP) --strip-unneeded $(OPENSSH_DIR)/sftp
	-$(STRIP) --strip-unneeded $(OPENSSH_DIR)/sftp-server
	-$(STRIP) --strip-unneeded $(OPENSSH_DIR)/ssh
	-$(STRIP) --strip-unneeded $(OPENSSH_DIR)/ssh-add
	-$(STRIP) --strip-unneeded $(OPENSSH_DIR)/ssh-agent
	-$(STRIP) --strip-unneeded $(OPENSSH_DIR)/ssh-keygen
	-$(STRIP) --strip-unneeded $(OPENSSH_DIR)/ssh-keyscan
	-$(STRIP) --strip-unneeded $(OPENSSH_DIR)/ssh-keysign
	-$(STRIP) --strip-unneeded $(OPENSSH_DIR)/ssh-rand-helper
	-$(STRIP) --strip-unneeded $(OPENSSH_DIR)/sshd

$(TARGET_DIR)/usr/bin/ssh: $(OPENSSH_DIR)/ssh
	$(MAKE) CC=$(TARGET_CC) DESTDIR=$(TARGET_DIR) -C $(OPENSSH_DIR) install
	rm -rf $(TARGET_DIR)/usr/info $(TARGET_DIR)/usr/man $(TARGET_DIR)/usr/share/doc

openssh: $(TARGET_DIR)/usr/bin/ssh

openssh-clean: 
	$(MAKE) -C $(OPENSSH_DIR) clean

openssh-dirclean: 
	rm -rf $(OPENSSH_DIR)

