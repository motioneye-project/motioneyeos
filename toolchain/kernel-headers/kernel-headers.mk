#############################################################
#
# Setup the kernel headers. I include a generic package of
# kernel headers here, so you shouldn't need to include your
# own. Be aware these kernel headers _will_ get blown away
# by a 'make clean' so don't put anything sacred in here...
#
#############################################################

DEFAULT_KERNEL_HEADERS:=$(call qstrip,$(BR2_DEFAULT_KERNEL_HEADERS))

LINUX_HEADERS_SITE:=127.0.0.1
LINUX_HEADERS_SOURCE:=unspecified-kernel-headers
LINUX_HEADERS_UNPACK_DIR:=$(TOOLCHAIN_DIR)/linux-libc-headers-null

include toolchain/kernel-headers/kernel-headers-new.makefile

$(DL_DIR)/$(LINUX_HEADERS_SOURCE):
ifeq ($(BR2_KERNEL_HEADERS_SNAP),y)
	$(error No local $@ found, cannot continue. Are you sure you wanted to enable BR2_KERNEL_HEADERS_SNAP?)
endif
	$(call DOWNLOAD,$(LINUX_HEADERS_SITE),$(LINUX_HEADERS_SOURCE))

kernel-headers: $(LINUX_HEADERS_DIR)/.configured

kernel-headers-source: $(DL_DIR)/$(LINUX_HEADERS_SOURCE)

kernel-headers-clean: clean
	rm -rf $(LINUX_HEADERS_DIR)

kernel-headers-dirclean:
	rm -rf $(LINUX_HEADERS_DIR)
	rm -rf $(LINUX_HEADERS_UNPACK_DIR)

.PHONY: kernel-headers
