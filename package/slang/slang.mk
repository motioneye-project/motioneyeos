################################################################################
#
# slang
#
################################################################################

SLANG_VERSION_MAJOR = 2.2
SLANG_VERSION = $(SLANG_VERSION_MAJOR).4
SLANG_SOURCE = slang-$(SLANG_VERSION).tar.bz2
SLANG_SITE = ftp://ftp.fu-berlin.de/pub/unix/misc/slang/v$(SLANG_VERSION_MAJOR)/
SLANG_LICENSE = GPLv2+
SLANG_LICENSE_FILES = COPYING
SLANG_INSTALL_STAGING = YES
SLANG_MAKE = $(MAKE1)

# The installation location of the slang library
# does not take into account the DESTDIR directory.
# So SLANG_INST_LIB is initialized with -L/usr/lib/
# and slang may be linked with host's libdl.so (if any)
# Therefore, we have to pass correct installation paths.
SLANG_INSTALL_STAGING_OPT = \
	prefix=$(STAGING_DIR)/usr \
	exec_prefix=$(STAGING_DIR)/usr \
	DESTDIR=$(STAGING_DIR) \
	install

SLANG_INSTALL_TARGET_OPT = \
	prefix=$(STAGING_DIR)/usr \
	exec_prefix=$(STAGING_DIR)/usr \
	DESTDIR=$(TARGET_DIR) \
	install

$(eval $(autotools-package))
