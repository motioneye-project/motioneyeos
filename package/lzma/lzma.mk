#############################################################
#
# lzma
#
#############################################################
LZMA_VERSION:=4.32.4
LZMA_SOURCE:=lzma-$(LZMA_VERSION).tar.gz
LZMA_CAT:=$(ZCAT)
LZMA_SITE:=http://tukaani.org/lzma/
LZMA_HOST_DIR:=$(TOOL_BUILD_DIR)/lzma-$(LZMA_VERSION)
LZMA_TARGET_DIR:=$(BUILD_DIR)/lzma-$(LZMA_VERSION)
LZMA_TARGET_BINARY:=bin/lzma

# lzma binary for use on the host
LZMA=$(TOOL_BUILD_DIR)/bin/lzma
HOST_LZMA_BINARY=$(shell $(CONFIG_SHELL) package/lzma/lzmacheck.sh)
HOST_LZMA_IF_ANY=$(shell $(CONFIG_SHELL) toolchain/dependencies/check-host-lzma.sh)


$(DL_DIR)/$(LZMA_SOURCE):
	$(WGET) -P $(DL_DIR) $(LZMA_SITE)/$(LZMA_SOURCE)

######################################################################
#
# lzma host
#
######################################################################

$(LZMA_HOST_DIR)/.unpacked: $(DL_DIR)/$(LZMA_SOURCE)
	$(LZMA_CAT) $(DL_DIR)/$(LZMA_SOURCE) | tar -C $(TOOL_BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(LZMA_HOST_DIR) package/lzma/ lzma\*.patch
	touch $@

$(LZMA_HOST_DIR)/.configured: $(LZMA_HOST_DIR)/.unpacked
	(cd $(LZMA_HOST_DIR); rm -f config.cache;\
		CC="$(HOSTCC)" \
		CXX="$(HOSTCXX)" \
		./configure \
		--prefix=/ \
	)
	touch $@

$(LZMA_HOST_DIR)/src/lzma/lzma: $(LZMA_HOST_DIR)/.configured
	$(MAKE) -C $(LZMA_HOST_DIR) all
	touch -c $@

$(STAGING_DIR)/bin/lzma: $(LZMA_HOST_DIR)/src/lzma/lzma
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(LZMA_HOST_DIR) install
	$(SED) "s,^libdir=.*,libdir=\'$(STAGING_DIR)/lib\',g" \
		$(STAGING_DIR)/lib/liblzmadec.la

.PHONY: lzma-host use-lzma-host-binary
use-lzma-host-binary:
	if [ ! -f "$(TOOL_BUILD_DIR)/bin/lzma" ]; then \
		[ -d $(TOOL_BUILD_DIR)/bin ] || mkdir -p $(TOOL_BUILD_DIR)/bin; \
		ln -sf "$(HOST_LZMA_IF_ANY)" "$(TOOL_BUILD_DIR)/bin/lzma"; \
	fi

build-lzma-host-binary: $(LZMA_HOST_DIR)/src/lzma/lzma
	-rm -f $(TOOL_BUILD_DIR)/bin/lzma
	[ -d $(TOOL_BUILD_DIR)/bin ] || mkdir $(TOOL_BUILD_DIR)/bin
	cp -pf $(LZMA_HOST_DIR)/src/lzma/lzma $(TOOL_BUILD_DIR)/bin/lzma

host-lzma: $(HOST_LZMA_BINARY)

lzma-host: $(STAGING_DIR)/bin/lzma

lzma-host-clean:
	rm -f $(STAGING_DIR)/bin/lzma
	-$(MAKE) -C $(LZMA_HOST_DIR) clean
lzma-host-dirclean:
	rm -rf $(LZMA_HOST_DIR)

lzma-host-install: /usr/local/bin/lzma

######################################################################
#
# lzma target
#
######################################################################

$(LZMA_TARGET_DIR)/.unpacked: $(DL_DIR)/$(LZMA_SOURCE)
	$(LZMA_CAT) $(DL_DIR)/$(LZMA_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(LZMA_TARGET_DIR) package/lzma/ lzma\*.patch
	touch $@

$(LZMA_TARGET_DIR)/.configured: $(LZMA_TARGET_DIR)/.unpacked
	(cd $(LZMA_TARGET_DIR); rm -f config.cache;\
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		ac_cv_func_malloc_0_nonnull=yes \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=$(TARGET_DIR)/usr/bin \
		--libdir=$(TARGET_DIR)/lib \
		--includedir=$(TARGET_DIR)/include \
		--disable-debug \
		$(DISABLE_NLS) \
		$(DISABLE_LARGEFILE) \
	)
	touch $@

$(LZMA_TARGET_DIR)/src/lzma/lzma: $(LZMA_TARGET_DIR)/.configured
	$(MAKE) -C $(LZMA_TARGET_DIR) all
	touch -c $@

$(TARGET_DIR)/$(LZMA_TARGET_BINARY): $(LZMA_TARGET_DIR)/src/lzma/lzma
	cp -dpf $(LZMA_TARGET_DIR)/src/lzma/lzma $@
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $@
	touch -c $@

#lzma-headers: $(TARGET_DIR)/$(LZMA_TARGET_BINARY)

lzma-target: uclibc $(TARGET_DIR)/$(LZMA_TARGET_BINARY)

lzma-source: $(DL_DIR)/$(LZMA_SOURCE)

lzma-clean:
	rm -f $(TARGET_DIR)/usr/bin/lzma
	-$(MAKE) -C $(LZMA_TARGET_DIR) clean

lzma-dirclean:
	rm -rf $(LZMA_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LZMA_HOST)),y)
TARGETS+=lzma-host
HOST_SOURCE+=lzma-source
endif

ifeq ($(strip $(BR2_PACKAGE_LZMA_TARGET)),y)
TARGETS+=lzma-target
endif

#ifeq ($(strip $(BR2_PACKAGE_LZMA_TARGET_HEADERS)),y)
#TARGETS+=lzma-headers
#endif
