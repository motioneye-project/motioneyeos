################################################################################
#
# toolchain-external-linaro-aarch64-be
#
################################################################################

TOOLCHAIN_EXTERNAL_LINARO_AARCH64_BE_VERSION = 2018.05
TOOLCHAIN_EXTERNAL_LINARO_AARCH64_BE_SITE = https://releases.linaro.org/components/toolchain/binaries/7.3-$(TOOLCHAIN_EXTERNAL_LINARO_AARCH64_BE_VERSION)/aarch64_be-linux-gnu

ifeq ($(HOSTARCH),x86)
TOOLCHAIN_EXTERNAL_LINARO_AARCH64_BE_SOURCE = gcc-linaro-7.3.1-$(TOOLCHAIN_EXTERNAL_LINARO_AARCH64_BE_VERSION)-i686_aarch64_be-linux-gnu.tar.xz
else
TOOLCHAIN_EXTERNAL_LINARO_AARCH64_BE_SOURCE = gcc-linaro-7.3.1-$(TOOLCHAIN_EXTERNAL_LINARO_AARCH64_BE_VERSION)-x86_64_aarch64_be-linux-gnu.tar.xz
endif

$(eval $(toolchain-external-package))
