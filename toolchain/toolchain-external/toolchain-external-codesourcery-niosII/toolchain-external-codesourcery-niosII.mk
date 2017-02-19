################################################################################
#
# toolchain-external-codesourcery-niosII
#
################################################################################

TOOLCHAIN_EXTERNAL_CODESOURCERY_NIOSII_VERSION = 2016.11-32

TOOLCHAIN_EXTERNAL_CODESOURCERY_NIOSII_SITE = http://sourcery.mentor.com/public/gnu_toolchain/$(TOOLCHAIN_EXTERNAL_PREFIX)
TOOLCHAIN_EXTERNAL_CODESOURCERY_NIOSII_SOURCE = sourceryg++-$(TOOLCHAIN_EXTERNAL_CODESOURCERY_NIOSII_VERSION)-$(TOOLCHAIN_EXTERNAL_PREFIX)-i686-pc-linux-gnu.tar.bz2
TOOLCHAIN_EXTERNAL_CODESOURCERY_NIOSII_ACTUAL_SOURCE_TARBALL = sourceryg++-$(TOOLCHAIN_EXTERNAL_CODESOURCERY_NIOSII_VERSION)-$(TOOLCHAIN_EXTERNAL_PREFIX).src.tar.bz2

$(eval $(toolchain-external-package))
