################################################################################
#
# libconfuse
#
################################################################################

LIBCONFUSE_VERSION = V2_7
LIBCONFUSE_SITE = $(call github,martinh,libconfuse,$(LIBCONFUSE_VERSION))
LIBCONFUSE_INSTALL_STAGING = YES
LIBCONFUSE_CONF_OPT = --disable-rpath
LIBCONFUSE_DEPENDENCIES = host-flex
LIBCONFUSE_LICENSE = ISC
LIBCONFUSE_LICENSE_FILES = src/confuse.c

# Fresh from the repository, no configure et al.
LIBCONFUSE_AUTORECONF = YES
LIBCONFUSE_GETTEXTIZE = YES

$(eval $(autotools-package))
$(eval $(host-autotools-package))
