################################################################################
#
# toolchain-external-sourcery-sh
#
################################################################################

TOOLCHAIN_EXTERNAL_CODESOURCERY_SH_VERSION = 2012.09-61

TOOLCHAIN_EXTERNAL_CODESOURCERY_SH_SITE = https://sourcery.mentor.com/public/gnu_toolchain/$(TOOLCHAIN_EXTERNAL_PREFIX)
TOOLCHAIN_EXTERNAL_CODESOURCERY_SH_SOURCE = renesas-$(TOOLCHAIN_EXTERNAL_CODESOURCERY_SH_VERSION)-$(TOOLCHAIN_EXTERNAL_PREFIX)-i686-pc-linux-gnu.tar.bz2
TOOLCHAIN_EXTERNAL_CODESOURCERY_SH_ACTUAL_SOURCE_TARBALL = renesas-$(TOOLCHAIN_EXTERNAL_CODESOURCERY_SH_VERSION)-$(TOOLCHAIN_EXTERNAL_PREFIX).src.tar.bz2

$(eval $(toolchain-external-package))
