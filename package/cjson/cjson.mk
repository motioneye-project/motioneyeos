################################################################################
#
# cjson
#
################################################################################

CJSON_VERSION = v1.5.6
CJSON_SITE = $(call github,DaveGamble,cjson,$(CJSON_VERSION))
CJSON_INSTALL_STAGING = YES
CJSON_LICENSE = MIT
CJSON_LICENSE_FILES = LICENSE
# Set ENABLE_CUSTOM_COMPILER_FLAGS to OFF in particular to disable
# -fstack-protector-strong which depends on BR2_TOOLCHAIN_HAS_SSP
CJSON_CONF_OPTS += \
	-DENABLE_CJSON_TEST=OFF \
	-DENABLE_CUSTOM_COMPILER_FLAGS=OFF

$(eval $(cmake-package))
