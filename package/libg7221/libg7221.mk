################################################################################
#
# libg7221
#
################################################################################

LIBG7221_VERSION = dbfc29d4806ecdace50379a2f4d68a992a6fec34
# we use the FreeSwitch fork because it contains pkgconf support
LIBG7221_SITE = https://freeswitch.org/stash/scm/sd/libg7221.git
LIBG7221_SITE_METHOD = git
LIBG7221_LICENSE = Polycom
LIBG7221_LICENSE_FILES = COPYING
LIBG7221_AUTORECONF = YES
LIBG7221_INSTALL_STAGING = YES

$(eval $(autotools-package))
