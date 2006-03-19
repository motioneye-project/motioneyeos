#############################################################
#
# bash
#
#############################################################
BASH_VER:=3.1
BASH_SOURCE:=bash-$(BASH_VER).tar.gz
BASH_SITE:=ftp://ftp.gnu.org/gnu/bash
BASH_CAT:=zcat
BASH_DIR:=$(BUILD_DIR)/bash-$(BASH_VER)
BASH_BINARY:=bash
BASH_TARGET_BINARY:=bin/bash

$(DL_DIR)/$(BASH_SOURCE):
	 $(WGET) -P $(DL_DIR) $(BASH_SITE)/$(BASH_SOURCE)

bash-source: $(DL_DIR)/$(BASH_SOURCE)

$(BASH_DIR)/.unpacked: $(DL_DIR)/$(BASH_SOURCE)
	$(BASH_CAT) $(DL_DIR)/$(BASH_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(BASH_DIR) package/bash/ bash??-*
	# This is broken when -lintl is added to LIBS
	$(SED) 's,LIBS_FOR_BUILD =.*,LIBS_FOR_BUILD =,g' \
		$(BASH_DIR)/builtins/Makefile.in
	touch $(BASH_DIR)/.unpacked

$(BASH_DIR)/.configured: $(BASH_DIR)/.unpacked
	#		bash_cv_have_mbstate_t=yes
	(cd $(BASH_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) CC_FOR_BUILD="$(HOSTCC)" \
		CFLAGS="$(TARGET_CFLAGS)" \
		ac_cv_func_setvbuf_reversed=no \
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
		$(DISABLE_LARGEFILE) \
		--with-curses \
		--enable-alias \
		--without-bash-malloc \
	);
	touch $(BASH_DIR)/.configured

$(BASH_DIR)/$(BASH_BINARY): $(BASH_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) CC_FOR_BUILD="$(HOSTCC)" -C $(BASH_DIR)

$(TARGET_DIR)/$(BASH_TARGET_BINARY): $(BASH_DIR)/$(BASH_BINARY)
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(BASH_DIR) install
	rm -f $(TARGET_DIR)/bin/bash*
	mv $(TARGET_DIR)/usr/bin/bash* $(TARGET_DIR)/bin/
	(cd $(TARGET_DIR)/bin; /bin/ln -fs bash sh)
	rm -rf $(TARGET_DIR)/share/locale $(TARGET_DIR)/usr/info \
		$(TARGET_DIR)/usr/man $(TARGET_DIR)/usr/share/doc

#If both bash and busybox are selected, make certain bash wins
#the fight over who gets to own the /bin/sh symlink
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
bash: ncurses uclibc busybox $(TARGET_DIR)/$(BASH_TARGET_BINARY)
else
bash: ncurses uclibc $(TARGET_DIR)/$(BASH_TARGET_BINARY)
endif

bash-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(BASH_DIR) uninstall
	-$(MAKE) -C $(BASH_DIR) clean

bash-dirclean:
	rm -rf $(BASH_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_BASH)),y)
TARGETS+=bash
endif
