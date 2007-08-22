#############################################################
#
# full kernel tarballs >= 2.6.19.1
#
#############################################################
ifeq ("$(DEFAULT_KERNEL_HEADERS)","2.6.22.1")
VERSION:=2
PATCHLEVEL:=6
SUBLEVEL:=22
EXTRAVERSION:=.1
LOCALVERSION:=
LINUX_HEADERS_VERSION:=$(VERSION).$(PATCHLEVEL).$(SUBLEVEL)$(EXTRAVERSION)
LINUX_HEADERS_SITE:=http://www.kernel.org/pub/linux/kernel/v2.6/
LINUX_HEADERS_SOURCE:=linux-$(LINUX_HEADERS_VERSION).tar.bz2
LINUX_HEADERS_CAT:=$(BZCAT)
LINUX_HEADERS_UNPACK_DIR:=$(BUILD_DIR)/linux-$(LINUX_HEADERS_VERSION)
LINUX_HEADERS_DIR:=$(TOOL_BUILD_DIR)/linux
LINUX_HEADERS_IS_KERNEL=y
endif

ifeq ("$(DEFAULT_KERNEL_HEADERS)","2.6.21.5")
VERSION:=2
PATCHLEVEL:=6
SUBLEVEL:=21
EXTRAVERSION:=.5
LOCALVERSION:=
LINUX_HEADERS_VERSION:=$(VERSION).$(PATCHLEVEL).$(SUBLEVEL)$(EXTRAVERSION)
LINUX_HEADERS_SITE:=http://www.kernel.org/pub/linux/kernel/v2.6/
LINUX_HEADERS_SOURCE:=linux-$(LINUX_HEADERS_VERSION).tar.bz2
LINUX_HEADERS_CAT:=$(BZCAT)
LINUX_HEADERS_UNPACK_DIR:=$(BUILD_DIR)/linux-$(LINUX_HEADERS_VERSION)
LINUX_HEADERS_DIR:=$(TOOL_BUILD_DIR)/linux
LINUX_HEADERS_IS_KERNEL=y
endif

ifeq ("$(DEFAULT_KERNEL_HEADERS)","2.6.20.4")
VERSION:=2
PATCHLEVEL:=6
SUBLEVEL:=20
EXTRAVERSION:=.4
LOCALVERSION:=
LINUX_HEADERS_VERSION:=$(VERSION).$(PATCHLEVEL).$(SUBLEVEL)$(EXTRAVERSION)
LINUX_HEADERS_SITE:=http://www.kernel.org/pub/linux/kernel/v2.6/
LINUX_HEADERS_SOURCE:=linux-$(LINUX_HEADERS_VERSION).tar.bz2
LINUX_HEADERS_CAT:=$(BZCAT)
LINUX_HEADERS_UNPACK_DIR:=$(BUILD_DIR)/linux-$(LINUX_HEADERS_VERSION)
LINUX_HEADERS_DIR:=$(TOOL_BUILD_DIR)/linux
LINUX_HEADERS_IS_KERNEL=y
endif

ifeq ($(LINUX_HEADERS_IS_KERNEL),y)
# Need to redefine KERNEL_HEADERS_PATCH_DIR if you want
# board specific kernel headers
KERNEL_HEADERS_PATCH_DIR:=toolchain/kernel-headers/empty

$(LINUX_HEADERS_UNPACK_DIR)/.unpacked: $(DL_DIR)/$(LINUX_HEADERS_SOURCE)
	@echo "*** Using kernel-headers generated from kernel source"
	rm -rf $(LINUX_HEADERS_DIR)
	[ -d $(BUILD_DIR) ] || $(INSTALL) -d $(BUILD_DIR)
	$(LINUX_HEADERS_CAT) $(DL_DIR)/$(LINUX_HEADERS_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $@

$(LINUX_HEADERS_UNPACK_DIR)/.patched: $(LINUX_HEADERS_UNPACK_DIR)/.unpacked
	toolchain/patch-kernel.sh $(LINUX_HEADERS_UNPACK_DIR) toolchain/kernel-headers \
		linux-$(LINUX_HEADERS_VERSION)-\*.patch{,.gz,.bz2}
ifeq ($(BR2_KERNEL_HEADERS_IPMI),y)
	toolchain/patch-kernel.sh $(LINUX_HEADERS_UNPACK_DIR) toolchain/kernel-headers/ipmi \
		linux-$(LINUX_HEADERS_VERSION)-\*.patch{,.gz,.bz2}
endif
ifeq ($(BR2_KERNEL_HEADERS_LZMA),y)
	toolchain/patch-kernel.sh $(LINUX_HEADERS_UNPACK_DIR) toolchain/kernel-headers/lzma \
		linux-$(LINUX_HEADERS_VERSION)-\*.patch{,.gz,.bz2}
endif
ifeq ($(BR2_KERNEL_HEADERS_PATCH_DIR),y)
	toolchain/patch-kernel.sh $(LINUX_HEADERS_UNPACK_DIR) $(KERNEL_HEADERS_PATCH_DIR) \
		\*.patch{,.gz,.bz2}
endif
ifeq ($(BR2_PACKAGE_OPENSWAN),y)
	toolchain/patch-kernel.sh $(LINUX_HEADERS_UNPACK_DIR) package/openswan \
		linux-$(LINUX_HEADERS_VERSION)-\*.patch{,.gz,.bz2}
endif
	touch $@

$(LINUX_HEADERS_DIR)/.configured: $(LINUX_HEADERS_UNPACK_DIR)/.patched
	(cd $(LINUX_HEADERS_UNPACK_DIR); \
	 $(MAKE) ARCH=$(KERNEL_ARCH) \
	 	HOSTCC="$(HOSTCC)" HOSTCFLAGS="$(HOSTCFLAGS)" \
		HOSTCXX="$(HOSTCXX)" \
		INSTALL_HDR_PATH=$(LINUX_HEADERS_DIR) headers_install; \
	)
	touch $@

endif
