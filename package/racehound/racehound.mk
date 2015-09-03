################################################################################
#
# racehound
#
################################################################################

RACEHOUND_VERSION = f3375911019607a0cb6a15bf68fa62dadd6b790b
RACEHOUND_SITE = $(call github,winnukem,racehound,$(RACEHOUND_VERSION))
RACEHOUND_LICENSE = GPLv2
RACEHOUND_LICENSE_FILES = LICENSE
RACEHOUND_SUPPORTS_IN_SOURCE_BUILD = NO

RACEHOUND_DEPENDENCIES = elfutils linux

# We're building a kernel module without using the kernel-module infra,
# so we need to tell we want module support in the kernel
ifeq ($(BR2_PACKAGE_RACEHOUND),y)
LINUX_NEEDS_MODULES = y
endif

# override auto detection (uses host parameters, not cross compile
# ready)
RACEHOUND_CONF_OPTS += \
	-DKERNEL_VERSION_OK=YES \
	-DMODULE_BUILD_SUPPORTED=YES \
	-DKERNEL_CONFIG_OK=YES \
	-DKBUILD_BUILD_DIR=$(LINUX_DIR) \
	-DKBUILD_VERSION_STRING=$(LINUX_VERSION_PROBED)

# cross compile environment for linux kernel module
RACEHOUND_MAKE_ENV = $(LINUX_MAKE_FLAGS)

$(eval $(cmake-package))
