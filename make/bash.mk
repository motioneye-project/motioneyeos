#############################################################
#
# bash
#
#############################################################
BASH_SOURCE:=bash-2.05b.tar.gz
BASH_SITE:=ftp://ftp.gnu.org/gnu/bash
BASH_CAT:=zcat
BASH_DIR:=$(BUILD_DIR)/bash-2.05b
BASH_BINARY:=bash
BASH_TARGET_BINARY:=bin/bash

$(DL_DIR)/$(BASH_SOURCE):
	 $(WGET) -P $(DL_DIR) $(BASH_SITE)/$(BASH_SOURCE)

bash-source: $(DL_DIR)/$(BASH_SOURCE)

$(BASH_DIR)/.unpacked: $(DL_DIR)/$(BASH_SOURCE)
	$(BASH_CAT) $(DL_DIR)/$(BASH_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	touch $(BASH_DIR)/.unpacked

$(BASH_DIR)/.configured: $(BASH_DIR)/.unpacked
	(cd $(BASH_DIR); rm -rf config.cache; \
		PATH=$(STAGING_DIR)/bin:$$PATH CC=$(TARGET_CC) \
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
		--disable-nls \
		--with-curses \
		--enable-alias \
	);
	touch  $(BASH_DIR)/.configured

$(BASH_DIR)/$(BASH_BINARY): $(BASH_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(BASH_DIR)

$(TARGET_DIR)/$(BASH_TARGET_BINARY): $(BASH_DIR)/$(BASH_BINARY)
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(BASH_DIR) install
	mv $(TARGET_DIR)/usr/bin/bash* $(TARGET_DIR)/bin/
	(cd $(TARGET_DIR)/bin; ln -fs bash sh)
	rm -rf $(TARGET_DIR)/share/locale $(TARGET_DIR)/usr/info \
		$(TARGET_DIR)/usr/man $(TARGET_DIR)/usr/share/doc

bash: ncurses uclibc $(TARGET_DIR)/$(BASH_TARGET_BINARY)

bash-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(BASH_DIR) uninstall
	-$(MAKE) -C $(BASH_DIR) clean

bash-dirclean:
	rm -rf $(BASH_DIR)

