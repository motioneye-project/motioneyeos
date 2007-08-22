#############################################################
#
# kexec
#
#############################################################
KEXEC_VERSION:=1.101
KEXEC_SOURCE:=kexec-tools_$(KEXEC_VERSION)-kdump10.orig.tar.gz
KEXEC_PATCH:=kexec-tools_$(KEXEC_VERSION)-kdump10-2.diff.gz
KEXEC_SITE:=ftp://ftp.debian.org/debian/pool/main/k/kexec-tools/
KEXEC_DIR:=$(BUILD_DIR)/kexec-tools-$(KEXEC_VERSION)
KEXEC_CAT:=$(ZCAT)
KEXEC_BINARY:=kexec
KEXEC_TARGET_BINARY:=sbin/kexec

KEXEC_CONFIG_OPTS:=
KEXEC_DEPS_y:=

KEXEC_DEPS_$(KEXEC_PACKAGE_KEXEC) += zlib

ifeq ($(strip $(BR2_PACKAGE_KEXEC_ZLIB)),y)
KEXEC_CONFIG_OPTS += --with-zlib
else
KEXEC_CONFIG_OPTS += --without-zlib
endif

$(DL_DIR)/$(KEXEC_SOURCE):
	$(WGET) -P $(DL_DIR) $(KEXEC_SITE)/$(KEXEC_SOURCE)

$(DL_DIR)/$(KEXEC_PATCH):
	$(WGET) -P $(DL_DIR) $(KEXEC_SITE)/$(KEXEC_PATCH)

kexec-source: $(DL_DIR)/$(KEXEC_SOURCE) $(DL_DIR)/$(KEXEC_PATCH)

$(KEXEC_DIR)/.unpacked: $(DL_DIR)/$(KEXEC_SOURCE) $(DL_DIR)/$(KEXEC_PATCH)
	$(KEXEC_CAT) $(DL_DIR)/$(KEXEC_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
ifneq ($(KEXEC_PATCH),)
	(cd $(KEXEC_DIR) && $(KEXEC_CAT) $(DL_DIR)/$(KEXEC_PATCH) | patch -p1; \
	for f in `cat debian/patches/00list`; do \
		cat debian/patches/$$f | patch -p2; \
	done)
endif
	toolchain/patch-kernel.sh $(KEXEC_DIR) package/kexec/ kexec\*.patch
	touch $@

$(KEXEC_DIR)/.configured: $(KEXEC_DIR)/.unpacked
	(cd $(KEXEC_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/ \
		$(KEXEC_CONFIG_OPTS) \
	)
	touch $@

$(KEXEC_DIR)/objdir-$(GNU_TARGET_NAME)/build/sbin/$(KEXEC_BINARY): $(KEXEC_DIR)/.configured
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(KEXEC_DIR)
	touch -c $@

$(TARGET_DIR)/$(KEXEC_TARGET_BINARY): $(KEXEC_DIR)/objdir-$(GNU_TARGET_NAME)/build/sbin/$(KEXEC_BINARY)
	cp -dpf $(KEXEC_DIR)/objdir-$(GNU_TARGET_NAME)/build/sbin/$(KEXEC_BINARY) \
		$(KEXEC_DIR)/objdir-$(GNU_TARGET_NAME)/build/sbin/kdump \
		$(TARGET_DIR)/sbin/
	$(STRIP) $(STRIP_STRIP_ALL) $(TARGET_DIR)/sbin/k{exec,dump}

kexec: uclibc $(TARGET_DIR)/$(KEXEC_TARGET_BINARY)

kexec-clean:
	-$(MAKE) -C $(KEXEC_DIR) clean
	rm -f $(TARGET_DIR)/sbin/k{exec,dump}

kexec-dirclean:
	rm -rf $(KEXEC_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_KEXEC)),y)
TARGETS+=kexec
endif
