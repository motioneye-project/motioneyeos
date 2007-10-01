#############################################################
#
# cvs
#
#############################################################
CVS_VERSION:=1.12.13
CVS_SOURCE:=cvs_$(CVS_VERSION).orig.tar.gz
CVS_PATCH:=cvs_$(CVS_VERSION)-8.diff.gz
CVS_SITE:=http://ftp.debian.org/debian/pool/main/c/cvs/
CVS_DIR:=$(BUILD_DIR)/cvs-$(CVS_VERSION)
CVS_CAT:=$(ZCAT)
CVS_BINARY:=src/cvs
CVS_TARGET_BINARY:=usr/bin/cvs

CVS_CONFIGURE_ARGS:=--disable-old-info-format-support
ifeq ($(BR2_PACKAGE_CVS_SERVER),y)
CVS_CONFIGURE_ARGS+=--enable-server
else
CVS_CONFIGURE_ARGS+=--disable-server
endif
ifeq ($(BR2_PACKAGE_ZLIB),y)
CVS_CONFIGURE_ARGS+=--with-external-zlib
endif

$(DL_DIR)/$(CVS_SOURCE):
	$(WGET) -P $(DL_DIR) $(CVS_SITE)/$(CVS_SOURCE)

ifneq ($(CVS_PATCH),)
CVS_PATCH_FILE=$(DL_DIR)/$(CVS_PATCH)
$(CVS_PATCH_FILE):
	$(WGET) -P $(DL_DIR) $(CVS_SITE)/$(CVS_PATCH)
endif
cvs-source: $(DL_DIR)/$(CVS_SOURCE) $(CVS_PATCH_FILE)

$(CVS_DIR)/.unpacked: $(DL_DIR)/$(CVS_SOURCE) $(CVS_PATCH_FILE)
	-mkdir $(CVS_DIR)
	$(CVS_CAT) $(DL_DIR)/$(CVS_SOURCE) | tar -C $(CVS_DIR) $(TAR_OPTIONS) -
	$(BZCAT) $(CVS_DIR)/cvs-$(CVS_VERSION)/cvs-$(CVS_VERSION).tar.bz2 | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	rm -rf $(CVS_DIR)/cvs-$(CVS_VERSION)
	$(CONFIG_UPDATE) $(CVS_DIR)
	toolchain/patch-kernel.sh $(CVS_DIR) package/cvs \*$(CVS_VERSION)\*.patch
ifneq ($(CVS_PATCH),)
	toolchain/patch-kernel.sh $(CVS_DIR) $(DL_DIR) $(CVS_PATCH)
	if [ -d $(CVS_DIR)/debian/patches ]; then \
		(cd $(CVS_DIR)/debian/patches && for i in *; \
		 do $(SED) 's,^\+\+\+ .*cvs-$(CVS_VERSION)/,+++ cvs-$(CVS_VERSION)/,' $$i; \
		 done; \
		); \
		toolchain/patch-kernel.sh $(CVS_DIR) $(CVS_DIR)/debian/patches \*; \
	fi
endif
	touch $@

$(CVS_DIR)/.configured: $(CVS_DIR)/.unpacked
	(cd $(CVS_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		cvs_cv_func_printf_ptr=yes \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		$(DISABLE_LARGEFILE) \
		$(DISABLE_NLS) \
		$(CVS_CONFIGURE_ARGS) \
	)
	touch $@

$(CVS_DIR)/$(CVS_BINARY): $(CVS_DIR)/.configured
	$(MAKE) -C $(CVS_DIR)

$(TARGET_DIR)/$(CVS_TARGET_BINARY): $(CVS_DIR)/$(CVS_BINARY)
	install -D $(CVS_DIR)/$(CVS_BINARY) $(TARGET_DIR)/$(CVS_TARGET_BINARY)
	$(STRIPCMD) $(STRIP_STRIP_ALL) $(TARGET_DIR)/$(CVS_TARGET_BINARY)

cvs: uclibc ncurses $(TARGET_DIR)/$(CVS_TARGET_BINARY)

cvs-clean:
	-$(MAKE) -C $(CVS_DIR) clean
	rm -f $(TARGET_DIR)/$(CVS_TARGET_BINARY)

cvs-dirclean:
	rm -rf $(CVS_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_CVS)),y)
TARGETS+=cvs
endif
