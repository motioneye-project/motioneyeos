#############################################################
#
# bash
#
#############################################################
BASH_VERSION:=3.2
BASH_SOURCE:=bash-$(BASH_VERSION).tar.gz
BASH_SITE:=$(BR2_GNU_MIRROR)/bash
BASH_CAT:=$(ZCAT)
BASH_DIR:=$(BUILD_DIR)/bash-$(BASH_VERSION)
BASH_BINARY:=bash
BASH_TARGET_BINARY:=bin/bash

$(DL_DIR)/$(BASH_SOURCE):
	 $(WGET) -P $(DL_DIR) $(BASH_SITE)/$(BASH_SOURCE)

bash-source: $(DL_DIR)/$(BASH_SOURCE)

bash-unpacked: $(BASH_DIR)/.unpacked

$(BASH_DIR)/.unpacked: $(DL_DIR)/$(BASH_SOURCE)
	$(BASH_CAT) $(DL_DIR)/$(BASH_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(BASH_DIR) package/bash/ bash??-\*
	# This is broken when -lintl is added to LIBS
	$(SED) 's,LIBS_FOR_BUILD =.*,LIBS_FOR_BUILD =,g' \
		$(BASH_DIR)/builtins/Makefile.in
	# using target's LDFLAGS as LDFLAGS_FOR_BUILD is b0rked
	-$(SED) '/^LDFLAGS_FOR_BUILD/d' $(BASH_DIR)/{,*/{,*/}}Makefile.in
	$(CONFIG_UPDATE) $(BASH_DIR)/support
	touch $@

$(BASH_DIR)/.configured: $(BASH_DIR)/.unpacked
	# bash_cv_have_mbstate_t=yes
	(cd $(BASH_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		CCFLAGS_FOR_BUILD="$(HOST_CFLAGS)" \
		ac_cv_func_setvbuf_reversed=no \
		ac_cv_have_decl_sys_siglist=yes \
		bash_cv_job_control_missing=present \
		bash_cv_sys_named_pipes=present \
		bash_cv_unusable_rtsigs=no \
		bash_cv_func_ctype_nonascii=yes \
		bash_cv_decl_under_sys_siglist=yes \
		bash_cv_ulimit_maxfds=yes \
		bash_cv_getcwd_malloc=yes \
		bash_cv_func_sigsetjmp=present \
		bash_cv_printf_a_format=yes \
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
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--includedir=/usr/include \
		$(DISABLE_NLS) \
		$(DISABLE_LARGEFILE) \
		--with-curses \
		--enable-alias \
		--without-bash-malloc \
		$(ENABLE_DEBUG) \
	)
	touch $@

$(BASH_DIR)/$(BASH_BINARY): $(BASH_DIR)/.configured
	$(MAKE1) CC=$(TARGET_CC) CC_FOR_BUILD="$(HOSTCC)" -C $(BASH_DIR)

$(TARGET_DIR)/$(BASH_TARGET_BINARY): $(BASH_DIR)/$(BASH_BINARY)
	mkdir -p $(TARGET_DIR)/bin
	$(MAKE1) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(BASH_DIR) install
	rm -f $(TARGET_DIR)/bin/bash*
	mv $(TARGET_DIR)/usr/bin/bash* $(TARGET_DIR)/bin/
	(cd $(TARGET_DIR)/bin; /bin/ln -fs bash sh)
ifneq ($(BR2_HAVE_INFOPAGES),y)
	rm -rf $(TARGET_DIR)/usr/share/info
endif
ifneq ($(BR2_HAVE_MANPAGES),y)
	rm -rf $(TARGET_DIR)/usr/share/man
endif
	rm -rf $(TARGET_DIR)/share/locale
	rm -rf $(TARGET_DIR)/usr/share/doc

# If both bash and busybox are selected, make certain bash wins
# the fight over who gets to own the /bin/sh symlink.
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
bash: ncurses uclibc busybox $(TARGET_DIR)/$(BASH_TARGET_BINARY)
else
bash: ncurses uclibc $(TARGET_DIR)/$(BASH_TARGET_BINARY)
endif

# If both bash and busybox are selected, the /bin/sh symlink
# may need to be reinstated by the clean targets.
bash-clean:
	-$(MAKE1) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(BASH_DIR) uninstall
	rm -f $(TARGET_DIR)/$(BASH_TARGET_BINARY)
	-$(MAKE1) -C $(BASH_DIR) clean

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
