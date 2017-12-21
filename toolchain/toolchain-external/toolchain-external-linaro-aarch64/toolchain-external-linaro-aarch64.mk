################################################################################
#
# toolchain-external-linaro-aarch64
#
################################################################################

TOOLCHAIN_EXTERNAL_LINARO_AARCH64_VERSION = 2017.11
TOOLCHAIN_EXTERNAL_LINARO_AARCH64_SITE = https://releases.linaro.org/components/toolchain/binaries/7.2-$(TOOLCHAIN_EXTERNAL_LINARO_AARCH64_VERSION)/aarch64-linux-gnu

ifeq ($(HOSTARCH),x86)
TOOLCHAIN_EXTERNAL_LINARO_AARCH64_SOURCE = gcc-linaro-7.2.1-$(TOOLCHAIN_EXTERNAL_LINARO_AARCH64_VERSION)-i686_aarch64-linux-gnu.tar.xz
else
TOOLCHAIN_EXTERNAL_LINARO_AARCH64_SOURCE = gcc-linaro-7.2.1-$(TOOLCHAIN_EXTERNAL_LINARO_AARCH64_VERSION)-x86_64_aarch64-linux-gnu.tar.xz
endif

$(eval $(toolchain-external-package))
