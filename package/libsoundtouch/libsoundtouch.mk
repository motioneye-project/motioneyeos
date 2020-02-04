################################################################################
#
# libsoundtouch
#
################################################################################

LIBSOUNDTOUCH_VERSION = 010a91a59071c7fefd316fca62c0d980ec85b4b1
LIBSOUNDTOUCH_SITE = https://freeswitch.org/stash/scm/sd/libsoundtouch.git
LIBSOUNDTOUCH_SITE_METHOD = git
LIBSOUNDTOUCH_LICENSE = LGPL-2.1+
LIBSOUNDTOUCH_LICENSE_FILES = COPYING.TXT
LIBSOUNDTOUCH_AUTORECONF = YES
LIBSOUNDTOUCH_INSTALL_STAGING = YES

$(eval $(autotools-package))
