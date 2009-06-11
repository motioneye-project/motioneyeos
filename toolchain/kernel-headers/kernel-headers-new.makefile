#############################################################
#
# full kernel tarballs >= 2.6.19.1
#
#############################################################

# parse linux version string
LNXVER:=$(subst ., , $(strip $(DEFAULT_KERNEL_HEADERS)))
VERSION:=$(word 1, $(LNXVER))
PATCHLEVEL:=$(word 2, $(LNXVER))
SUBLEVEL:=$(word 3, $(LNXVER))
EXTRAVERSION:=$(word 4, $(LNXVER))
LOCALVERSION:=

# should contain prepended dot
EXTRAVERSION:=$(if $(EXTRAVERSION),.$(EXTRAVERSION),)

LINUX_HEADERS_VERSION:=$(VERSION).$(PATCHLEVEL).$(SUBLEVEL)$(EXTRAVERSION)
LINUX_HEADERS_SITE:=$(BR2_KERNEL_MIRROR)/linux/kernel/v2.6/
LINUX_HEADERS_SOURCE:=linux-$(LINUX_HEADERS_VERSION).tar.bz2
LINUX_HEADERS_CAT:=$(BZCAT)
LINUX_HEADERS_UNPACK_DIR:=$(TOOL_BUILD_DIR)/linux-$(LINUX_HEADERS_VERSION)
LINUX_HEADERS_DIR:=$(TOOL_BUILD_DIR)/linux

ifeq ("$(DEFAULT_KERNEL_HEADERS)","2.6.26.8")
LINUX_RT_VERSION:=rt16
endif

LINUX_HEADERS_DEPENDS:=

ifeq ($(BR2_KERNEL_HEADERS_RT),y)
LINUX_RT_SOURCE:=patch-$(LINUX_HEADERS_VERSION)-$(LINUX_RT_VERSION)
LINUX_RT_SITE:=$(BR2_KERNEL_MIRROR)/linux/kernel/projects/rt
LINUX_HEADERS_DEPENDS+=$(DL_DIR)/$(LINUX_RT_SOURCE)
$(DL_DIR)/$(LINUX_RT_SOURCE):
	$(call DOWNLOAD,$(LINUX_RT_SITE),$(LINUX_RT_SOURCE))
endif

$(LINUX_HEADERS_UNPACK_DIR)/.unpacked: $(DL_DIR)/$(LINUX_HEADERS_SOURCE)
	@echo "*** Using kernel-headers generated from kernel source"
	rm -rf $(LINUX_HEADERS_DIR)
	[ -d $(TOOL_BUILD_DIR) ] || $(INSTALL) -d $(TOOL_BUILD_DIR)
	$(LINUX_HEADERS_CAT) $(DL_DIR)/$(LINUX_HEADERS_SOURCE) | tar -C $(TOOL_BUILD_DIR) $(TAR_OPTIONS) -
	touch $@

$(LINUX_HEADERS_UNPACK_DIR)/.patched: $(LINUX_HEADERS_UNPACK_DIR)/.unpacked $(LINUX_HEADERS_DEPENDS)
	toolchain/patch-kernel.sh $(LINUX_HEADERS_UNPACK_DIR) toolchain/kernel-headers \
		linux-$(LINUX_HEADERS_VERSION)-\*.patch{,.gz,.bz2}
ifeq ($(BR2_KERNEL_HEADERS_RT),y)
	toolchain/patch-kernel.sh $(LINUX_HEADERS_UNPACK_DIR) $(DL_DIR) $(LINUX_RT_SOURCE)
endif
ifneq ($(KERNEL_HEADERS_PATCH_DIR),)
	toolchain/patch-kernel.sh $(LINUX_HEADERS_UNPACK_DIR) $(KERNEL_HEADERS_PATCH_DIR) \
		linux-$(LINUX_HEADERS_VERSION)-\*.patch{,.gz,.bz2}
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
ifeq ($(BR2_ARCH),"cris")
	ln -s $(LINUX_HEADERS_DIR)/include/arch-v10/arch $(LINUX_HEADERS_DIR)/include/arch
	cp -a $(LINUX_HEADERS_UNPACK_DIR)/include/linux/user.h $(LINUX_HEADERS_DIR)/include/linux
	$(SED) "/^#include <asm\/page\.h>/d" $(LINUX_HEADERS_DIR)/include/asm/user.h
endif
	touch $@
