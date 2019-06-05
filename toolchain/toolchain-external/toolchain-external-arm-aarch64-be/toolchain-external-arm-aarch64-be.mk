################################################################################
#
# toolchain-external-arm-aarch64-be
#
################################################################################

TOOLCHAIN_EXTERNAL_ARM_AARCH64_BE_VERSION = 2019.03
TOOLCHAIN_EXTERNAL_ARM_AARCH64_BE_SITE = https://developer.arm.com/-/media/Files/downloads/gnu-a/8.3-$(TOOLCHAIN_EXTERNAL_ARM_AARCH64_BE_VERSION)/binrel

TOOLCHAIN_EXTERNAL_ARM_AARCH64_BE_SOURCE = gcc-arm-8.3-$(TOOLCHAIN_EXTERNAL_ARM_AARCH64_BE_VERSION)-x86_64-aarch64_be-linux-gnu.tar.xz

$(eval $(toolchain-external-package))
