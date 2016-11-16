################################################################################
#
# boot-wrapper-aarch64
#
################################################################################

BOOT_WRAPPER_AARCH64_VERSION = 4266507a84f8c06452109d38e0350d4759740694
BOOT_WRAPPER_AARCH64_SITE = git://git.kernel.org/pub/scm/linux/kernel/git/mark/boot-wrapper-aarch64.git
BOOT_WRAPPER_AARCH64_LICENSE = BSD3c
BOOT_WRAPPER_AARCH64_LICENSE_FILES = LICENSE.txt
BOOT_WRAPPER_AARCH64_DEPENDENCIES = linux
BOOT_WRAPPER_AARCH64_INSTALL_IMAGES = YES

# The Git repository does not have the generated configure script and
# Makefile.
BOOT_WRAPPER_AARCH64_AUTORECONF = YES

BOOT_WRAPPER_AARCH64_DTB = /arch/arm64/boot/dts/$(basename $(call qstrip,$(BR2_TARGET_BOOT_WRAPPER_AARCH64_DTS))).dtb

# Fixup the path to the DTB in configure.ac. In the future, this
# should hopefully be made more configurable by the
# boot-wrapper-aarch64 developers.
define BOOT_WRAPPER_AARCH64_FIX_DTB_NAME
	$(SED) 's%^KERN_DTB=.*%KERN_DTB=$(BOOT_WRAPPER_AARCH64_DTB)%' $(@D)/configure.ac
endef

BOOT_WRAPPER_AARCH64_PRE_PATCH_HOOKS += BOOT_WRAPPER_AARCH64_FIX_DTB_NAME

BOOT_WRAPPER_AARCH64_CONF_OPTS = \
	--with-kernel-dir=$(LINUX_DIR) \
	--with-cmdline=$(BR2_TARGET_BOOT_WRAPPER_AARCH64_BOOTARGS)

ifeq ($(BR2_TARGET_BOOT_WRAPPER_AARCH64_PSCI),y)
BOOT_WRAPPER_AARCH64_CONF_OPTS += --enable-psci
else
BOOT_WRAPPER_AARCH64_CONF_OPTS += --disable-psci
endif

# We need to convince the configure script that the Linux kernel tree
# exists, as well as the DTB and the kernel Image. Even though those
# are available on the build machine, the configure script uses
# AC_CHECK_FILE tests, which are always disabled in cross-compilation
# situations.
BOOT_WRAPPER_AARCH64_CONF_ENV = \
	$(call AUTOCONF_AC_CHECK_FILE_VAL,$(LINUX_DIR))=yes \
	$(call AUTOCONF_AC_CHECK_FILE_VAL,$(LINUX_DIR)$(BOOT_WRAPPER_AARCH64_DTB))=yes \
	$(call AUTOCONF_AC_CHECK_FILE_VAL,$(LINUX_DIR)/arch/arm64/boot/Image)=yes

define BOOT_WRAPPER_AARCH64_INSTALL_IMAGES_CMDS
	cp $(@D)/linux-system.axf $(BINARIES_DIR)
endef

$(eval $(autotools-package))
