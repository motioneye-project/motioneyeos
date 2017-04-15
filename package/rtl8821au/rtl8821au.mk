################################################################################
#
# rtl8821au
#
################################################################################

RTL8821AU_VERSION = b018b446fb0729fa659e7eead475d6c13f192642
RTL8821AU_SITE = $(call github,abperiasamy,rtl8812AU_8821AU_linux,$(RTL8821AU_VERSION))
RTL8821AU_LICENSE = GPL-2.0
RTL8821AU_LICENSE_FILES = COPYING

RTL8821AU_MODULE_MAKE_OPTS = \
	CONFIG_RTL8812AU_8821AU=m \
	KVER=$(LINUX_VERSION_PROBED) \
	USER_EXTRA_CFLAGS="-DCONFIG_$(call qstrip,$(BR2_ENDIAN))_ENDIAN \
		-Wno-error"

$(eval $(kernel-module))
$(eval $(generic-package))
