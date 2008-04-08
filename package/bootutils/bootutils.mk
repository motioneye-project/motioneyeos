#############################################################
#
# bootutils
#
#############################################################
BOOTUTILS_VERSION:=0.0.7
BOOTUTILS_SOURCE:=bootutils-$(BOOTUTILS_VERSION).tar.gz
BOOTUTILS_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/bootutils
BOOTUTILS_CAT:=$(ZCAT)
BOOTUTILS_DIR:=$(BUILD_DIR)/bootutils-$(BOOTUTILS_VERSION)
BOOTUTILS_BINARIES:=switchroot raidscan

$(DL_DIR)/$(BOOTUTILS_SOURCE):
	 $(WGET) -P $(DL_DIR) $(BOOTUTILS_SITE)/$(BOOTUTILS_SOURCE)

$(BOOTUTILS_DIR)/.unpacked: $(DL_DIR)/$(BOOTUTILS_SOURCE)
	$(BOOTUTILS_CAT) $(DL_DIR)/$(BOOTUTILS_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(BOOTUTILS_DIR) package/bootutils \*.patch
	touch $@

$(BOOTUTILS_DIR)/.configured: $(BOOTUTILS_DIR)/.unpacked
	(cd $(BOOTUTILS_DIR); rm -rf config.cache ; \
	$(TARGET_CONFIGURE_OPTS) \
	CFLAGS="$(TARGET_CFLAGS)" \
		ac_cv_func_malloc_0_nonnull=yes \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/ \
	);
	touch $@

BOOTUTILS_BUILD_TARGETS:=$(addprefix $(BOOTUTILS_DIR)/,$(BOOTUTILS_BINARIES))
BOOTUTILS_PROGS:=$(addprefix $(TARGET_DIR)/sbin/,$(BOOTUTILS_BINARIES))

$(BOOTUTILS_BUILD_TARGETS): $(BOOTUTILS_DIR)/.configured
	$(MAKE) -C $(BOOTUTILS_DIR)

$(BOOTUTILS_PROGS): $(BOOTUTILS_BUILD_TARGETS)
	$(MAKE) -C $(BOOTUTILS_DIR) DESTDIR=$(TARGET_DIR) install

#####################################################################
.PHONY: bootutils-source bootutils bootutils-clean bootutils-dirclean

bootutils: uclibc $(BOOTUTILS_PROGS)

bootutils-source: $(DL_DIR)/$(BOOTUTILS_SOURCE)

bootutils-clean: $(BOOTUTILS_CLEAN_DEPS)
	-$(MAKE) -C $(BOOTUTILS_DIR) DESTDIR=$(TARGET_DIR) uninstall clean


bootutils-dirclean: $(BOOTUTILS_DIRCLEAN_DEPS)
	rm -rf $(BOOTUTILS_DIR)


#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_BOOTUTILS)),y)
TARGETS+=bootutils
endif

