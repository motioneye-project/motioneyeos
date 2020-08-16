################################################################################
#
# rtl8821au
#
################################################################################

RTL8821AU_VERSION = 4235b0ec7d7220a6364586d8e25b1e8cb99c36f1
RTL8821AU_SITE = $(call github,abperiasamy,rtl8812AU_8821AU_linux,$(RTL8821AU_VERSION))
RTL8821AU_LICENSE = GPL-2.0
RTL8821AU_LICENSE_FILES = LICENSE

RTL8821AU_MODULE_MAKE_OPTS = \
	CONFIG_RTL8812AU_8821AU=m \
	KVER=$(LINUX_VERSION_PROBED) \
	USER_EXTRA_CFLAGS="-DCONFIG_$(call qstrip,$(BR2_ENDIAN))_ENDIAN \
		-Wno-error"

$(eval $(kernel-module))
$(eval $(generic-package))
