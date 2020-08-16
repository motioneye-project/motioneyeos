################################################################################
#
# grub2
#
################################################################################

GRUB2_VERSION = 2.04
GRUB2_SITE = http://ftp.gnu.org/gnu/grub
GRUB2_SOURCE = grub-$(GRUB2_VERSION).tar.xz
GRUB2_LICENSE = GPL-3.0+
GRUB2_LICENSE_FILES = COPYING
GRUB2_DEPENDENCIES = host-bison host-flex host-grub2
HOST_GRUB2_DEPENDENCIES = host-bison host-flex
GRUB2_INSTALL_IMAGES = YES

# 0001-build-Fix-GRUB-i386-pc-build-with-Ubuntu-gcc.patch
define GRUB2_AVOID_AUTORECONF
	$(Q)touch $(@D)/Makefile.util.am
	$(Q)touch $(@D)/Makefile.in
endef
GRUB2_POST_PATCH_HOOKS += GRUB2_AVOID_AUTORECONF
HOST_GRUB2_POST_PATCH_HOOKS += GRUB2_AVOID_AUTORECONF

ifeq ($(BR2_TARGET_GRUB2_INSTALL_TOOLS),y)
GRUB2_INSTALL_TARGET = YES
else
GRUB2_INSTALL_TARGET = NO
endif

GRUB2_BUILTIN_MODULES = $(call qstrip,$(BR2_TARGET_GRUB2_BUILTIN_MODULES))
GRUB2_BUILTIN_CONFIG = $(call qstrip,$(BR2_TARGET_GRUB2_BUILTIN_CONFIG))
GRUB2_BOOT_PARTITION = $(call qstrip,$(BR2_TARGET_GRUB2_BOOT_PARTITION))

ifeq ($(BR2_TARGET_GRUB2_I386_PC),y)
GRUB2_IMAGE = $(BINARIES_DIR)/grub.img
GRUB2_CFG = $(TARGET_DIR)/boot/grub/grub.cfg
GRUB2_PREFIX = ($(GRUB2_BOOT_PARTITION))/boot/grub
GRUB2_TUPLE = i386-pc
GRUB2_TARGET = i386
GRUB2_PLATFORM = pc
else ifeq ($(BR2_TARGET_GRUB2_I386_EFI),y)
GRUB2_IMAGE = $(BINARIES_DIR)/efi-part/EFI/BOOT/bootia32.efi
GRUB2_CFG = $(BINARIES_DIR)/efi-part/EFI/BOOT/grub.cfg
GRUB2_PREFIX = /EFI/BOOT
GRUB2_TUPLE = i386-efi
GRUB2_TARGET = i386
GRUB2_PLATFORM = efi
else ifeq ($(BR2_TARGET_GRUB2_X86_64_EFI),y)
GRUB2_IMAGE = $(BINARIES_DIR)/efi-part/EFI/BOOT/bootx64.efi
GRUB2_CFG = $(BINARIES_DIR)/efi-part/EFI/BOOT/grub.cfg
GRUB2_PREFIX = /EFI/BOOT
GRUB2_TUPLE = x86_64-efi
GRUB2_TARGET = x86_64
GRUB2_PLATFORM = efi
else ifeq ($(BR2_TARGET_GRUB2_ARM_UBOOT),y)
GRUB2_IMAGE = $(BINARIES_DIR)/boot-part/grub/grub.img
GRUB2_CFG = $(BINARIES_DIR)/boot-part/grub/grub.cfg
GRUB2_PREFIX = ($(GRUB2_BOOT_PARTITION))/boot/grub
GRUB2_TUPLE = arm-uboot
GRUB2_TARGET = arm
GRUB2_PLATFORM = uboot
else ifeq ($(BR2_TARGET_GRUB2_ARM_EFI),y)
GRUB2_IMAGE = $(BINARIES_DIR)/efi-part/EFI/BOOT/bootarm.efi
GRUB2_CFG = $(BINARIES_DIR)/efi-part/EFI/BOOT/grub.cfg
GRUB2_PREFIX = /EFI/BOOT
GRUB2_TUPLE = arm-efi
GRUB2_TARGET = arm
GRUB2_PLATFORM = efi
else ifeq ($(BR2_TARGET_GRUB2_ARM64_EFI),y)
GRUB2_IMAGE = $(BINARIES_DIR)/efi-part/EFI/BOOT/bootaa64.efi
GRUB2_CFG = $(BINARIES_DIR)/efi-part/EFI/BOOT/grub.cfg
GRUB2_PREFIX = /EFI/BOOT
GRUB2_TUPLE = arm64-efi
GRUB2_TARGET = aarch64
GRUB2_PLATFORM = efi
endif

# Grub2 is kind of special: it considers CC, LD and so on to be the
# tools to build the host programs and uses TARGET_CC, TARGET_CFLAGS,
# TARGET_CPPFLAGS, TARGET_LDFLAGS to build the bootloader itself.
#
# NOTE: TARGET_STRIP is overridden by !BR2_STRIP_strip, so always
# use the cross compile variant to ensure grub2 builds

HOST_GRUB2_CONF_ENV = \
	CPP="$(HOSTCC) -E"

GRUB2_CONF_ENV = \
	CPP="$(TARGET_CC) -E" \
	TARGET_CC="$(TARGET_CC)" \
	TARGET_CFLAGS="$(TARGET_CFLAGS)" \
	TARGET_CPPFLAGS="$(TARGET_CPPFLAGS) -fno-stack-protector" \
	TARGET_LDFLAGS="$(TARGET_LDFLAGS)" \
	TARGET_NM="$(TARGET_NM)" \
	TARGET_OBJCOPY="$(TARGET_OBJCOPY)" \
	TARGET_STRIP="$(TARGET_CROSS)strip"

GRUB2_CONF_OPTS = \
	--target=$(GRUB2_TARGET) \
	--with-platform=$(GRUB2_PLATFORM) \
	--prefix=/ \
	--exec-prefix=/ \
	--disable-grub-mkfont \
	--enable-efiemu=no \
	ac_cv_lib_lzma_lzma_code=no \
	--enable-device-mapper=no \
	--enable-libzfs=no \
	--disable-werror

HOST_GRUB2_CONF_OPTS = \
	--disable-grub-mkfont \
	--enable-efiemu=no \
	ac_cv_lib_lzma_lzma_code=no \
	--enable-device-mapper=no \
	--enable-libzfs=no \
	--disable-werror

ifeq ($(BR2_TARGET_GRUB2_I386_PC),y)
define GRUB2_IMAGE_INSTALL_ELTORITO
	cat $(HOST_DIR)/lib/grub/$(GRUB2_TUPLE)/cdboot.img $(GRUB2_IMAGE) > \
		$(BINARIES_DIR)/grub-eltorito.img
endef
endif

define GRUB2_INSTALL_IMAGES_CMDS
	mkdir -p $(dir $(GRUB2_IMAGE))
	$(HOST_DIR)/usr/bin/grub-mkimage \
		-d $(@D)/grub-core/ \
		-O $(GRUB2_TUPLE) \
		-o $(GRUB2_IMAGE) \
		-p "$(GRUB2_PREFIX)" \
		$(if $(GRUB2_BUILTIN_CONFIG),-c $(GRUB2_BUILTIN_CONFIG)) \
		$(GRUB2_BUILTIN_MODULES)
	mkdir -p $(dir $(GRUB2_CFG))
	$(INSTALL) -D -m 0644 boot/grub2/grub.cfg $(GRUB2_CFG)
	$(GRUB2_IMAGE_INSTALL_ELTORITO)
endef

ifeq ($(GRUB2_PLATFORM),efi)
define GRUB2_EFI_STARTUP_NSH
	echo $(notdir $(GRUB2_IMAGE)) > \
		$(BINARIES_DIR)/efi-part/startup.nsh
endef
GRUB2_POST_INSTALL_IMAGES_HOOKS += GRUB2_EFI_STARTUP_NSH
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
