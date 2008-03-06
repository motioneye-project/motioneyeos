#############################################################
#
# Vim Text Editor
#
#############################################################
VIM_VERSION:=7.1
VIM_SOURCE:=vim-$(VIM_VERSION).tar.bz2
VIM_EXTRA:=vim-$(VIM_VERSION)-extra.tar.gz
VIM_SITE:=ftp://ftp.vim.org/pub/vim
VIM_SOURCE_SITE:=$(VIM_SITE)/unix
VIM_EXTRA_SITE:=$(VIM_SITE)/extra
VIM_PATCH_SITE:=$(VIM_SITE)/patches/7.1
VIM_DIR:=$(BUILD_DIR)/vim71
VIM_PATCHES:=$(shell cat package/editors/vim/patches | sed -s 's:\([0-9]\{3\}\):$(DL_DIR)/vim/$(VIM_VERSION).\1:')
VIM_CONFIG_H:=$(VIM_DIR)/src/auto/config.h
VIM_CONFIG_MK:=$(VIM_DIR)/src/auto/config.mk

$(DL_DIR)/$(VIM_SOURCE):
	$(WGET) -P $(DL_DIR) $(VIM_SOURCE_SITE)/$(VIM_SOURCE)

$(DL_DIR)/$(VIM_EXTRA):
	$(WGET) -P $(DL_DIR) $(VIM_EXTRA_SITE)/$(VIM_EXTRA)

$(DL_DIR)/vim/%:
	$(WGET) -P $(DL_DIR)/vim/ $(VIM_PATCH_SITE)/$*

vim-source: $(DL_DIR)/$(VIM_SOURCE) $(DL_DIR)/$(VIM_EXTRA) $(VIM_PATCHES)

$(VIM_DIR)/.unpacked: $(DL_DIR)/$(VIM_SOURCE)
	$(BZCAT) $(DL_DIR)/$(VIM_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	$(ZCAT) $(DL_DIR)/$(VIM_EXTRA) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $@

$(VIM_DIR)/.patched: $(VIM_DIR)/.unpacked
	@for i in $(VIM_PATCHES); do ( \
		echo "Patching with $$i"; \
		cd $(VIM_DIR); \
		patch -p0 < $$i) \
    done;
	toolchain/patch-kernel.sh $(VIM_DIR) package/editors/vim/ \*.patch
	touch $@

$(VIM_DIR)/.configured: $(VIM_DIR)/.patched
	(cd $(VIM_DIR)/src; \
		PATH=$(TARGET_PATH) \
		CC="$(TARGET_CC)" \
		CPP="$(TARGET_CPP)" \
		CFLAGS="$(TARGET_CFLAGS)" \
		STRIP="$(TARGET_STRIP)" \
		PKG_CONFIG_SYSROOT="$(STAGING_DIR)" \
		PKG_CONFIG="$(STAGING_DIR)/usr/bin/pkg-config" \
		PKG_CONFIG_PATH="$(STAGING_DIR)/usr/lib/pkgconfig:$(PKG_CONFIG_PATH)" \
		PKG_CONFIG_ALLOW_SYSTEM_CFLAGS=1 \
		PKG_CONFIG_ALLOW_SYSTEM_LIBS=1 \
        $(TARGET_CONFIGURE_ARGS) \
		./configure --prefix=/usr \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--sysconfdir=/etc \
		$(DISABLE_NLS) \
		--disable-netbeans \
		--disable-gpm \
		--disable-gui \
		--without-x \
		--with-tlib=ncurses \
	)
	touch $@

$(VIM_DIR)/.build: $(VIM_DIR)/.configured
	(cd $(VIM_DIR)/src; \
		$(MAKE) \
	)
	touch $@

$(TARGET_DIR)/usr/bin/vim: $(VIM_DIR)/.build
	(cd $(VIM_DIR)/src; \
		make DESTDIR=$(TARGET_DIR) installvimbin; \
		make DESTDIR=$(TARGET_DIR) installlinks; \
	)
ifeq ($(R2_PACKAGE_VIM_RUNTIME),y)
	(cd $(VIM_DIR)/src; \
		make DESTDIR=$(TARGET_DIR) installrtbase; \
		make DESTDIR=$(TARGET_DIR) installmacros; \
	)
endif

vim: ncurses vim-source $(TARGET_DIR)/usr/bin/vim

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_VIM)),y)
TARGETS+=vim
endif
