################################################################################
#
# libconfuse
#
################################################################################

LIBCONFUSE_VERSION = 9413a82f9cb56a94f71fa420f146e841c5372ed8
LIBCONFUSE_SITE = $(call github,martinh,libconfuse,$(LIBCONFUSE_VERSION))
LIBCONFUSE_INSTALL_STAGING = YES
LIBCONFUSE_CONF_OPTS = --disable-rpath
LIBCONFUSE_DEPENDENCIES = host-flex
LIBCONFUSE_LICENSE = ISC
LIBCONFUSE_LICENSE_FILES = LICENSE

# Fresh from the repository, no configure et al.
LIBCONFUSE_AUTORECONF = YES
LIBCONFUSE_GETTEXTIZE = YES

$(eval $(autotools-package))
$(eval $(host-autotools-package))
