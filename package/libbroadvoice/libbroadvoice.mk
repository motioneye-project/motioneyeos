################################################################################
#
# libbroadvoice
#
################################################################################

LIBBROADVOICE_VERSION = f65b0f50c8c767229fbf1758370880abc0d78564
# we use the FreeSwitch fork because (quoting README):
# "This library is based on the Broadcom reference code, but has been
# heavily modified so that it builds into a proper library, with a clean
# usable interface, on a range of platforms."
LIBBROADVOICE_SITE = https://freeswitch.org/stash/scm/sd/libbroadvoice.git
LIBBROADVOICE_SITE_METHOD = git
LIBBROADVOICE_LICENSE = LGPLv2.1
LIBBROADVOICE_LICENSE_FILES = COPYING
LIBBROADVOICE_AUTORECONF = YES
LIBBROADVOICE_INSTALL_STAGING = YES

$(eval $(autotools-package))
