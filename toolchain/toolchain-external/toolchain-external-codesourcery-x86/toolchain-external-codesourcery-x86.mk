################################################################################
#
# toolchain-external-codesourcery-x86
#
################################################################################

TOOLCHAIN_EXTERNAL_CODESOURCERY_X86_SITE = https://sourcery.mentor.com/public/gnu_toolchain/$(TOOLCHAIN_EXTERNAL_PREFIX)
TOOLCHAIN_EXTERNAL_CODESOURCERY_X86_VERSION = 2012.09-62
TOOLCHAIN_EXTERNAL_CODESOURCERY_X86_SOURCE = ia32-$(TOOLCHAIN_EXTERNAL_CODESOURCERY_X86_VERSION)-$(TOOLCHAIN_EXTERNAL_PREFIX)-i386-linux.tar.bz2
TOOLCHAIN_EXTERNAL_CODESOURCERY_X86_ACTUAL_SOURCE_TARBALL = ia32-$(TOOLCHAIN_EXTERNAL_CODESOURCERY_X86_VERSION)-$(TOOLCHAIN_EXTERNAL_PREFIX).src.tar.bz2

$(eval $(toolchain-external-package))
