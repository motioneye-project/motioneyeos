################################################################################
#
# toolchain-external-codesourcery-aarch64
#
################################################################################

TOOLCHAIN_EXTERNAL_CODESOURCERY_AARCH64_SITE = http://sourcery.mentor.com/public/gnu_toolchain/$(TOOLCHAIN_EXTERNAL_PREFIX)
TOOLCHAIN_EXTERNAL_CODESOURCERY_AARCH64_VERSION = 2014.11-95
TOOLCHAIN_EXTERNAL_CODESOURCERY_AARCH64_SOURCE = aarch64-amd-$(TOOLCHAIN_EXTERNAL_CODESOURCERY_AARCH64_VERSION)-$(TOOLCHAIN_EXTERNAL_PREFIX)-i686-pc-linux-gnu.tar.bz2
TOOLCHAIN_EXTERNAL_CODESOURCERY_AARCH64_ACTUAL_SOURCE_TARBALL = aarch64-amd-$(TOOLCHAIN_EXTERNAL_CODESOURCERY_AARCH64_VERSION)-$(TOOLCHAIN_EXTERNAL_PREFIX).src.tar.bz2

$(eval $(toolchain-external-package))
