################################################################################
#
# slang
#
################################################################################

SLANG_VERSION_MAJOR = 2.2
SLANG_VERSION = $(SLANG_VERSION_MAJOR).4
SLANG_SOURCE = slang-$(SLANG_VERSION).tar.bz2
SLANG_SITE = ftp://ftp.fu-berlin.de/pub/unix/misc/slang/v$(SLANG_VERSION_MAJOR)/
SLANG_INSTALL_STAGING = YES
SLANG_MAKE = $(MAKE1)

$(eval $(autotools-package))
