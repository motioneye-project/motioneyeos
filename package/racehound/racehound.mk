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

RACEHOUND_CONF_OPTS += \
	-DKERNEL_VERSION_OK=YES \
	-DMODULE_BUILD_SUPPORTED=YES \
	-DKERNEL_CONFIG_OK=YES \
	-DKBUILD_BUILD_DIR=$(LINUX_DIR)

$(eval $(cmake-package))
