################################################################################
#
# grub2
#
################################################################################

GRUB2_VERSION = 2.00
GRUB2_SITE = $(BR2_GNU_MIRROR)/grub
GRUB2_SOURCE = grub-$(GRUB2_VERSION).tar.xz
GRUB2_LICENSE = GPLv3+
GRUB2_LICENSE_FILES = COPYING
GRUB2_DEPENDENCIES = host-bison host-flex

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
endif

# Grub2 is kind of special: it considers CC, LD and so on to be the
# tools to build the native tools (i.e to be executed on the build
# machine), and uses TARGET_CC, TARGET_CFLAGS, TARGET_CPPFLAGS to
# build the bootloader itself.

GRUB2_CONF_ENV = \
	$(HOST_CONFIGURE_OPTS) \
	CPP="$(HOSTCC) -E" \
	TARGET_CC="$(TARGET_CC)" \
	TARGET_CFLAGS="$(TARGET_CFLAGS)" \
	TARGET_CPPFLAGS="$(TARGET_CPPFLAGS)"

GRUB2_CONF_OPTS = \
	--target=$(GRUB2_TARGET) \
	--with-platform=$(GRUB2_PLATFORM) \
	--disable-grub-mkfont \
	--enable-efiemu=no \
	--enable-liblzma=no \
	--enable-device-mapper=no \
	--enable-libzfs=no \
	--disable-werror

# We don't want all the native tools and Grub2 modules to be installed
# in the target. So we in fact install everything into the host
# directory, and the image generation process (below) will use the
# grub-mkimage tool and Grub2 modules from the host directory.

GRUB2_INSTALL_TARGET_OPTS = DESTDIR=$(HOST_DIR) install

define GRUB2_IMAGE_INSTALLATION
	mkdir -p $(dir $(GRUB2_IMAGE))
	$(HOST_DIR)/usr/bin/grub-mkimage \
		-d $(HOST_DIR)/usr/lib/grub/$(GRUB2_TUPLE) \
		-O $(GRUB2_TUPLE) \
		-o $(GRUB2_IMAGE) \
		-p "$(GRUB2_PREFIX)" \
		$(if $(GRUB2_BUILTIN_CONFIG),-c $(GRUB2_BUILTIN_CONFIG)) \
		$(GRUB2_BUILTIN_MODULES)
	mkdir -p $(dir $(GRUB2_CFG))
	$(INSTALL) -D -m 0644 boot/grub2/grub.cfg $(GRUB2_CFG)
endef
GRUB2_POST_INSTALL_TARGET_HOOKS += GRUB2_IMAGE_INSTALLATION

ifeq ($(GRUB2_PLATFORM),efi)
define GRUB2_EFI_STARTUP_NSH
	echo $(notdir $(GRUB2_IMAGE)) > \
		$(BINARIES_DIR)/efi-part/startup.nsh
endef
GRUB2_POST_INSTALL_TARGET_HOOKS += GRUB2_EFI_STARTUP_NSH
endif

$(eval $(autotools-package))
