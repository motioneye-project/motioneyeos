################################################################################
#
# toolchain-external-codesourcery-amd64
#
################################################################################

TOOLCHAIN_EXTERNAL_CODESOURCERY_AMD64_SITE = https://sourcery.mentor.com/public/gnu_toolchain/$(TOOLCHAIN_EXTERNAL_PREFIX)
TOOLCHAIN_EXTERNAL_CODESOURCERY_AMD64_VERSION = 2016.11-19
TOOLCHAIN_EXTERNAL_CODESOURCERY_AMD64_SOURCE = amd-$(TOOLCHAIN_EXTERNAL_CODESOURCERY_AMD64_VERSION)-$(TOOLCHAIN_EXTERNAL_PREFIX)-i686-pc-linux-gnu.tar.bz2
TOOLCHAIN_EXTERNAL_CODESOURCERY_AMD64_ACTUAL_SOURCE_TARBALL = amd-$(TOOLCHAIN_EXTERNAL_CODESOURCERY_AMD64_VERSION)-$(TOOLCHAIN_EXTERNAL_PREFIX).src.tar.bz2

$(eval $(toolchain-external-package))
