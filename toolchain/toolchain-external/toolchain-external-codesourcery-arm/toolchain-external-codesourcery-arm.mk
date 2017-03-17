################################################################################
#
# toolchain-external-codesourcery-arm
#
################################################################################

TOOLCHAIN_EXTERNAL_CODESOURCERY_ARM_VERSION = 2014.05-29

TOOLCHAIN_EXTERNAL_CODESOURCERY_ARM_SITE = http://sourcery.mentor.com/public/gnu_toolchain/$(TOOLCHAIN_EXTERNAL_PREFIX)
TOOLCHAIN_EXTERNAL_CODESOURCERY_ARM_SOURCE = arm-$(TOOLCHAIN_EXTERNAL_CODESOURCERY_ARM_VERSION)-$(TOOLCHAIN_EXTERNAL_PREFIX)-i686-pc-linux-gnu.tar.bz2
TOOLCHAIN_EXTERNAL_CODESOURCERY_ARM_ACTUAL_SOURCE_TARBALL = arm-$(TOOLCHAIN_EXTERNAL_CODESOURCERY_ARM_VERSION)-$(TOOLCHAIN_EXTERNAL_PREFIX).src.tar.bz2

$(eval $(toolchain-external-package))
