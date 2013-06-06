################################################################################
#
# Setup the kernel headers. I include a generic package of
# kernel headers here, so you shouldn't need to include your
# own. Be aware these kernel headers _will_ get blown away
# by a 'make clean' so don't put anything sacred in here...
#
################################################################################

DEFAULT_KERNEL_HEADERS:=$(call qstrip,$(BR2_DEFAULT_KERNEL_HEADERS))

LINUX_HEADERS_SITE:=127.0.0.1
LINUX_HEADERS_SOURCE:=unspecified-kernel-headers
LINUX_HEADERS_UNPACK_DIR:=$(TOOLCHAIN_DIR)/linux-libc-headers-null

# parse linux version string
LNXVER:=$(subst ., , $(strip $(DEFAULT_KERNEL_HEADERS)))
VERSION:=$(word 1, $(LNXVER))
PATCHLEVEL:=$(word 2, $(LNXVER))
SUBLEVEL:=$(word 3, $(LNXVER))
EXTRAVERSION:=$(word 4, $(LNXVER))
LOCALVERSION:=

# should contain prepended dot
SUBLEVEL:=$(if $(SUBLEVEL),.$(SUBLEVEL),)
EXTRAVERSION:=$(if $(EXTRAVERSION),.$(EXTRAVERSION),)

LINUX_HEADERS_VERSION:=$(VERSION).$(PATCHLEVEL)$(SUBLEVEL)$(EXTRAVERSION)
ifeq ($(findstring x2.6.,x$(DEFAULT_KERNEL_HEADERS)),x2.6.)
LINUX_HEADERS_SITE:=$(BR2_KERNEL_MIRROR:/=)/linux/kernel/v2.6/
else
LINUX_HEADERS_SITE:=$(BR2_KERNEL_MIRROR:/=)/linux/kernel/v3.x/
endif
LINUX_HEADERS_SOURCE:=linux-$(LINUX_HEADERS_VERSION).tar.xz
LINUX_HEADERS_CAT:=$(XZCAT)
LINUX_HEADERS_UNPACK_DIR:=$(TOOLCHAIN_DIR)/linux-$(LINUX_HEADERS_VERSION)
LINUX_HEADERS_DIR:=$(TOOLCHAIN_DIR)/linux

LINUX_HEADERS_DEPENDS:=

$(LINUX_HEADERS_UNPACK_DIR)/.unpacked: $(DL_DIR)/$(LINUX_HEADERS_SOURCE)
	$(Q)$(call MESSAGE,"Extracting kernel headers")
	rm -rf $(LINUX_HEADERS_DIR)
	$(INSTALL) -d $(@D)
	$(LINUX_HEADERS_CAT) $(DL_DIR)/$(LINUX_HEADERS_SOURCE) | \
	tar $(TAR_STRIP_COMPONENTS)=1 -C $(@D) $(TAR_OPTIONS) -
	touch $@

$(LINUX_HEADERS_UNPACK_DIR)/.patched: $(LINUX_HEADERS_UNPACK_DIR)/.unpacked $(LINUX_HEADERS_DEPENDS)
	$(Q)$(call MESSAGE,"Patching kernel headers")
	support/scripts/apply-patches.sh $(LINUX_HEADERS_UNPACK_DIR) toolchain/kernel-headers \
		linux-$(LINUX_HEADERS_VERSION)-\*.patch{,.gz,.bz2}
ifneq ($(KERNEL_HEADERS_PATCH_DIR),)
	support/scripts/apply-patches.sh $(LINUX_HEADERS_UNPACK_DIR) $(KERNEL_HEADERS_PATCH_DIR) \
		linux-$(LINUX_HEADERS_VERSION)-\*.patch{,.gz,.bz2}
endif
	touch $@

$(LINUX_HEADERS_DIR)/.configured: $(LINUX_HEADERS_UNPACK_DIR)/.patched
	$(Q)$(call MESSAGE,"Installing kernel headers")
	(cd $(LINUX_HEADERS_UNPACK_DIR); \
	 $(MAKE) ARCH=$(KERNEL_ARCH) \
		HOSTCC="$(HOSTCC)" HOSTCFLAGS="$(HOSTCFLAGS)" \
		HOSTCXX="$(HOSTCXX)" \
		INSTALL_HDR_PATH=$(LINUX_HEADERS_DIR) headers_install; \
	)
	touch $@

$(DL_DIR)/$(LINUX_HEADERS_SOURCE):
ifeq ($(BR2_KERNEL_HEADERS_SNAP),y)
	$(error No local $@ found, cannot continue. Are you sure you wanted to enable BR2_KERNEL_HEADERS_SNAP?)
endif
	$(Q)$(call MESSAGE,"Downloading kernel headers")
	$(call DOWNLOAD,$(LINUX_HEADERS_SITE:/=)/$(LINUX_HEADERS_SOURCE))

kernel-headers: $(LINUX_HEADERS_DIR)/.configured

kernel-headers-source: $(DL_DIR)/$(LINUX_HEADERS_SOURCE)

kernel-headers-clean: clean
	rm -rf $(LINUX_HEADERS_DIR)

kernel-headers-dirclean:
	rm -rf $(LINUX_HEADERS_DIR)
	rm -rf $(LINUX_HEADERS_UNPACK_DIR)

.PHONY: kernel-headers
