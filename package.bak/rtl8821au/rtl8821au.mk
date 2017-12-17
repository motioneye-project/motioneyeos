################################################################################
#
# rtl8821au
#
################################################################################

RTL8821AU_VERSION = c33ddb05a77741d2a9c9b974ad0cf0fa26d17b6e
RTL8821AU_SITE = $(call github,abperiasamy,rtl8812AU_8821AU_linux,$(RTL8821AU_VERSION))
RTL8821AU_LICENSE = GPLv2
RTL8821AU_LICENSE_FILES = COPYING

RTL8821AU_MODULE_MAKE_OPTS = \
	CONFIG_RTL8812AU_8821AU=m \
	KVER=$(LINUX_VERSION_PROBED) \
	USER_EXTRA_CFLAGS=-DCONFIG_$(call qstrip,$(BR2_ENDIAN))_ENDIAN

$(eval $(kernel-module))
$(eval $(generic-package))
