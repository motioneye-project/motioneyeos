################################################################################
#
# barebox
#
################################################################################

################################################################################
# inner-barebox-package -- generates the KConfig logic and make targets needed
# to support a barebox package. All barebox packages are built from the same
# source (origin, version and patches). The remainder of the package
# configuration is unique to each barebox package.
#
#  argument 1 is the uppercase package name (used for variable name-space)
################################################################################

define inner-barebox-package

$(1)_VERSION = $$(call qstrip,$$(BR2_TARGET_BAREBOX_VERSION))

ifeq ($$($(1)_VERSION),custom)
# Handle custom Barebox tarballs as specified by the configuration
$(1)_TARBALL = $$(call qstrip,$$(BR2_TARGET_BAREBOX_CUSTOM_TARBALL_LOCATION))
$(1)_SITE = $$(patsubst %/,%,$$(dir $$($(1)_TARBALL)))
$(1)_SOURCE = $$(notdir $$($(1)_TARBALL))
else ifeq ($$(BR2_TARGET_BAREBOX_CUSTOM_GIT),y)
$(1)_SITE = $$(call qstrip,$$(BR2_TARGET_BAREBOX_CUSTOM_GIT_REPO_URL))
$(1)_SITE_METHOD = git
# Override the default value of _SOURCE to 'barebox-*' so that it is not
# downloaded a second time for barebox-aux; also alows avoiding the hash
# check:
$(1)_SOURCE = barebox-$$($(1)_VERSION).tar.gz
else
# Handle stable official Barebox versions
$(1)_SOURCE = barebox-$$($(1)_VERSION).tar.bz2
$(1)_SITE = https://www.barebox.org/download
endif

$(1)_DL_SUBDIR = barebox

$(1)_DEPENDENCIES = host-lzop
$(1)_LICENSE = GPL-2.0 with exceptions
ifeq ($(BR2_TARGET_BAREBOX_LATEST_VERSION),y)
$(1)_LICENSE_FILES = COPYING
endif

$(1)_CUSTOM_EMBEDDED_ENV_PATH = $$(call qstrip,$$(BR2_TARGET_$(1)_CUSTOM_EMBEDDED_ENV_PATH))

ifneq ($$(call qstrip,$$(BR2_TARGET_BAREBOX_CUSTOM_PATCH_DIR)),)
define $(1)_APPLY_CUSTOM_PATCHES
	$$(APPLY_PATCHES) $$(@D) \
		$$(BR2_TARGET_BAREBOX_CUSTOM_PATCH_DIR) \*.patch
endef

$(1)_POST_PATCH_HOOKS += $(1)_APPLY_CUSTOM_PATCHES
endif

$(1)_INSTALL_IMAGES = YES
ifneq ($$(BR2_TARGET_$(1)_BAREBOXENV),y)
$(1)_INSTALL_TARGET = NO
endif

ifeq ($$(KERNEL_ARCH),i386)
$(1)_ARCH = x86
else ifeq ($$(KERNEL_ARCH),x86_64)
$(1)_ARCH = x86
else ifeq ($$(KERNEL_ARCH),powerpc)
$(1)_ARCH = ppc
else ifeq ($$(KERNEL_ARCH),arm64)
$(1)_ARCH = arm
else
$(1)_ARCH = $$(KERNEL_ARCH)
endif

$(1)_MAKE_FLAGS = ARCH=$$($(1)_ARCH) CROSS_COMPILE="$$(TARGET_CROSS)"
$(1)_MAKE_ENV = $$(TARGET_MAKE_ENV)

ifeq ($$(BR2_TARGET_$(1)_USE_DEFCONFIG),y)
$(1)_KCONFIG_DEFCONFIG = $$(call qstrip,$$(BR2_TARGET_$(1)_BOARD_DEFCONFIG))_defconfig
else ifeq ($$(BR2_TARGET_$(1)_USE_CUSTOM_CONFIG),y)
$(1)_KCONFIG_FILE = $$(call qstrip,$$(BR2_TARGET_$(1)_CUSTOM_CONFIG_FILE))
endif

$(1)_KCONFIG_FRAGMENT_FILES = $$(call qstrip,$$(BR2_TARGET_$(1)_CONFIG_FRAGMENT_FILES))
$(1)_KCONFIG_EDITORS = menuconfig xconfig gconfig nconfig
$(1)_KCONFIG_OPTS = $$($(1)_MAKE_FLAGS)

$(1)_KCONFIG_DEPENDENCIES = \
	$(BR2_BISON_HOST_DEPENDENCY) \
	$(BR2_FLEX_HOST_DEPENDENCY)

ifeq ($$(BR2_TARGET_$(1)_BAREBOXENV),y)
define $(1)_BUILD_BAREBOXENV_CMDS
	$$(TARGET_CC) $$(TARGET_CFLAGS) $$(TARGET_LDFLAGS) -o $$(@D)/bareboxenv \
		$$(@D)/scripts/bareboxenv.c
endef
endif

ifeq ($$(BR2_TARGET_$(1)_CUSTOM_ENV),y)
$(1)_ENV_NAME = $$(notdir $$(call qstrip,\
	$$(BR2_TARGET_$(1)_CUSTOM_ENV_PATH)))
define $(1)_BUILD_CUSTOM_ENV
	$$(@D)/scripts/bareboxenv -s \
		$$(call qstrip, $$(BR2_TARGET_$(1)_CUSTOM_ENV_PATH)) \
		$$(@D)/$$($(1)_ENV_NAME)
endef
define $(1)_INSTALL_CUSTOM_ENV
	cp $$(@D)/$$($(1)_ENV_NAME) $$(BINARIES_DIR)
endef
endif

ifneq ($$($(1)_CUSTOM_EMBEDDED_ENV_PATH),)
define $(1)_KCONFIG_FIXUP_CMDS
	$$(call KCONFIG_ENABLE_OPT,CONFIG_DEFAULT_ENVIRONMENT)
	$$(call KCONFIG_SET_OPT,CONFIG_DEFAULT_ENVIRONMENT_PATH,"$$($(1)_CUSTOM_EMBEDDED_ENV_PATH)")
endef
endif

define $(1)_BUILD_CMDS
	$$($(1)_BUILD_BAREBOXENV_CMDS)
	$$(TARGET_MAKE_ENV) $$(MAKE) $$($(1)_MAKE_FLAGS) -C $$(@D)
	$$($(1)_BUILD_CUSTOM_ENV)
endef

$(1)_IMAGE_FILES = $$(call qstrip,$$(BR2_TARGET_$(1)_IMAGE_FILE))

define $(1)_INSTALL_IMAGES_CMDS
	if test -n "$$($(1)_IMAGE_FILES)"; then \
		cp -L $$(foreach image,$$($(1)_IMAGE_FILES),$$(@D)/$$(image)) $$(BINARIES_DIR) ; \
	elif test -h $$(@D)/barebox-flash-image ; then \
		cp -L $$(@D)/barebox-flash-image $$(BINARIES_DIR)/barebox.bin ; \
	else \
		cp $$(@D)/barebox.bin $$(BINARIES_DIR);\
	fi
	$$($(1)_INSTALL_CUSTOM_ENV)
endef

ifeq ($$(BR2_TARGET_$(1)_BAREBOXENV),y)
define $(1)_INSTALL_TARGET_CMDS
	cp $$(@D)/bareboxenv $$(TARGET_DIR)/usr/bin
endef
endif

# Checks to give errors that the user can understand
# Must be before we call to kconfig-package
ifeq ($$(BR2_TARGET_$(1))$$(BR_BUILDING),yy)
# We must use the user-supplied kconfig value, because
# $(1)_KCONFIG_DEFCONFIG will at least contain the
# trailing _defconfig
ifeq ($$(or $$($(1)_KCONFIG_FILE),$$(call qstrip,$$(BR2_TARGET_$(1)_BOARD_DEFCONFIG))),)
$$(error No Barebox config. Check your BR2_TARGET_$(1)_BOARD_DEFCONFIG or BR2_TARGET_$(1)_CUSTOM_CONFIG_FILE settings)
endif
endif

$$(eval $$(kconfig-package))

endef

################################################################################
# barebox-package -- the target generator macro for barebox packages
################################################################################

barebox-package=$(call inner-barebox-package,$(call UPPERCASE,$(pkgname)))

include boot/barebox/barebox/barebox.mk
include boot/barebox/barebox-aux/barebox-aux.mk

ifeq ($(BR2_TARGET_BAREBOX)$(BR2_TARGET_BAREBOX_LATEST_VERSION),y)
BR_NO_CHECK_HASH_FOR += $(BAREBOX_SOURCE)
endif
