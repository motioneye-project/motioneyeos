######################################################################
#
# gdb
#
######################################################################
GDB_VERSION:=$(call qstrip,$(BR2_GDB_VERSION))

GDB_SOURCE:=gdb-$(GDB_VERSION).tar.bz2
GDB_CAT:=$(BZCAT)

ifeq ($(findstring avr32,$(GDB_VERSION)),avr32)
 GDB_SITE:=ftp://www.at91.com/pub/buildroot/
 GDB_PATCH_DIR:=toolchain/gdb/$(GDB_VERSION)
else
 GDB_SITE:=$(BR2_GNU_MIRROR)/gdb
 GDB_PATCH_DIR:=toolchain/gdb/$(GDB_VERSION)
endif

ifneq ($(filter xtensa%,$(ARCH)),)
include target/xtensa/patch.in
GDB_PATCH_EXTRA:=$(call XTENSA_PATCH,gdb,$(GDB_PATCH_DIR),. ..)
endif

GDB_DIR:=$(TOOLCHAIN_DIR)/gdb-$(GDB_VERSION)

$(DL_DIR)/$(GDB_SOURCE):
	$(call DOWNLOAD,$(GDB_SITE)/$(GDB_SOURCE))

gdb-unpacked: $(GDB_DIR)/.unpacked
$(GDB_DIR)/.unpacked: $(DL_DIR)/$(GDB_SOURCE)
	mkdir -p $(GDB_DIR)
	$(GDB_CAT) $(DL_DIR)/$(GDB_SOURCE) | tar -C $(GDB_DIR) $(TAR_STRIP_COMPONENTS)=1 $(TAR_OPTIONS) -
ifneq ($(wildcard $(GDB_PATCH_DIR)),)
	support/scripts/apply-patches.sh $(GDB_DIR) $(GDB_PATCH_DIR) \*.patch $(GDB_PATCH_EXTRA)
endif
	$(call CONFIG_UPDATE,$(@D))
	touch $@

gdb-patched: $(GDB_DIR)/.unpacked

gdb-source: $(DL_DIR)/$(GDB_SOURCE)
gdb-dirclean:
	rm -rf $(GDB_DIR)

######################################################################
#
# gdb target
#
######################################################################

GDB_TARGET_DIR:=$(BUILD_DIR)/gdb-$(GDB_VERSION)-target

GDB_TARGET_CONFIGURE_VARS:= \
	ac_cv_type_uintptr_t=yes \
	gt_cv_func_gettext_libintl=yes \
	ac_cv_func_dcgettext=yes \
	gdb_cv_func_sigsetjmp=yes \
	bash_cv_func_strcoll_broken=no \
	bash_cv_must_reinstall_sighandlers=no \
	bash_cv_func_sigsetjmp=present \
	bash_cv_have_mbstate_t=yes

$(GDB_TARGET_DIR)/.configured: $(GDB_DIR)/.unpacked
	mkdir -p $(GDB_TARGET_DIR)
	(cd $(GDB_TARGET_DIR); \
		gdb_cv_func_sigsetjmp=yes \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS_FOR_TARGET="$(TARGET_CFLAGS) $(TARGET_LDFLAGS) -Wno-error" \
		CFLAGS="$(TARGET_CFLAGS) $(TARGET_LDFLAGS) -Wno-error" \
		$(GDB_TARGET_CONFIGURE_VARS) \
		$(GDB_DIR)/configure $(QUIET) \
		--cache-file=/dev/null \
		--build=$(GNU_HOST_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--target=$(GNU_TARGET_NAME) \
		--prefix=/usr \
		$(DISABLE_NLS) \
		--without-uiout $(DISABLE_GDBMI) \
		--disable-tui --disable-gdbtk --without-x \
		--disable-sim --enable-gdbserver \
		--without-included-gettext \
		--disable-werror \
		$(QUIET) \
	)
ifeq ($(BR2_ENABLE_LOCALE),y)
	-$(SED) "s,^INTL *=.*,INTL = -lintl,g;" $(GDB_DIR)/gdb/Makefile
endif
	touch $@

$(GDB_TARGET_DIR)/gdb/gdb: $(GDB_TARGET_DIR)/.configured
	# force ELF support since it fails due to BFD linking problems
	gdb_cv_var_elf=yes \
	$(TARGET_MAKE_ENV) \
	$(MAKE) CC="$(TARGET_CC)" MT_CFLAGS="$(TARGET_CFLAGS)" \
		-C $(GDB_TARGET_DIR)

$(TARGET_DIR)/usr/bin/gdb: $(GDB_TARGET_DIR)/gdb/gdb
	install -c -D $(GDB_TARGET_DIR)/gdb/gdb $(TARGET_DIR)/usr/bin/gdb

gdb_target: ncurses $(TARGET_DIR)/usr/bin/gdb

gdb_target-source: $(DL_DIR)/$(GDB_SOURCE)

gdb_target-clean:
	-$(MAKE) -C $(GDB_DIR) clean

gdb_target-dirclean:
	rm -rf $(GDB_DIR)

######################################################################
#
# gdbserver
#
######################################################################

GDB_SERVER_DIR:=$(BUILD_DIR)/gdbserver-$(GDB_VERSION)

$(GDB_SERVER_DIR)/.configured: $(GDB_DIR)/.unpacked
	mkdir -p $(GDB_SERVER_DIR)
	(cd $(GDB_SERVER_DIR); \
		$(TARGET_CONFIGURE_OPTS) \
		gdb_cv_func_sigsetjmp=yes \
		bash_cv_have_mbstate_t=yes \
		$(GDB_DIR)/gdb/gdbserver/configure $(QUIET) \
		--cache-file=/dev/null \
		--build=$(GNU_HOST_NAME) \
		--host=$(GNU_TARGET_NAME) \
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
		--includedir=$(STAGING_DIR)/usr/include \
		$(DISABLE_NLS) \
		--without-uiout $(DISABLE_GDBMI) \
		--disable-tui --disable-gdbtk --without-x \
		--without-included-gettext \
	)
	touch $@

$(GDB_SERVER_DIR)/gdbserver: $(GDB_SERVER_DIR)/.configured
	$(MAKE) CC="$(TARGET_CC)" MT_CFLAGS="$(TARGET_CFLAGS)" \
		-C $(GDB_SERVER_DIR)

$(TARGET_DIR)/usr/bin/gdbserver: $(GDB_SERVER_DIR)/gdbserver
ifeq ($(BR2_CROSS_TOOLCHAIN_TARGET_UTILS),y)
	mkdir -p $(STAGING_DIR)/usr/$(GNU_TARGET_NAME)/target_utils
	install -c $(GDB_SERVER_DIR)/gdbserver \
		$(STAGING_DIR)/usr/$(GNU_TARGET_NAME)/target_utils/gdbserver
endif
	install -c -D $(GDB_SERVER_DIR)/gdbserver $(TARGET_DIR)/usr/bin/gdbserver

gdbserver: $(TARGET_DIR)/usr/bin/gdbserver

gdbserver-source: $(DL_DIR)/$(GDB_SOURCE)

gdbserver-clean:
	-$(MAKE) -C $(GDB_SERVER_DIR) clean

gdbserver-dirclean:
	rm -rf $(GDB_SERVER_DIR)

######################################################################
#
# gdb on host
#
######################################################################

GDB_HOST_DIR:=$(TOOLCHAIN_DIR)/gdbhost-$(GDB_VERSION)

$(GDB_HOST_DIR)/.configured: $(GDB_DIR)/.unpacked
	mkdir -p $(GDB_HOST_DIR)
	(cd $(GDB_HOST_DIR); \
		gdb_cv_func_sigsetjmp=yes \
		bash_cv_have_mbstate_t=yes \
		$(HOST_CONFIGURE_OPTS) \
		$(GDB_DIR)/configure $(QUIET) \
		--cache-file=/dev/null \
		--prefix=$(STAGING_DIR) \
		--build=$(GNU_HOST_NAME) \
		--host=$(GNU_HOST_NAME) \
		--target=$(GNU_TARGET_NAME) \
		$(DISABLE_NLS) \
		--without-uiout $(DISABLE_GDBMI) \
		--disable-tui --disable-gdbtk --without-x \
		--without-included-gettext \
		--enable-threads \
		--disable-werror \
	)
	touch $@

$(GDB_HOST_DIR)/gdb/gdb: $(GDB_HOST_DIR)/.configured
	# force ELF support since it fails due to BFD linking problems
	gdb_cv_var_elf=yes \
	$(MAKE) -C $(GDB_HOST_DIR)
	strip $(GDB_HOST_DIR)/gdb/gdb

$(TARGET_CROSS)gdb: $(GDB_HOST_DIR)/gdb/gdb
	install -c $(GDB_HOST_DIR)/gdb/gdb $(TARGET_CROSS)gdb
	ln -snf $(@F) $(HOST_DIR)/usr/bin/$(ARCH)-linux-gdb

gdbhost: host-expat $(TARGET_CROSS)gdb

gdbhost-source: $(DL_DIR)/$(GDB_SOURCE)

gdbhost-clean:
	-$(MAKE) -C $(GDB_HOST_DIR) clean

gdbhost-dirclean:
	rm -rf $(GDB_HOST_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_GDB),y)
TARGETS+=gdb_target
endif

ifeq ($(BR2_PACKAGE_GDB_SERVER),y)
TARGETS+=gdbserver
endif

ifeq ($(BR2_PACKAGE_GDB_HOST),y)
TARGETS+=gdbhost
endif
