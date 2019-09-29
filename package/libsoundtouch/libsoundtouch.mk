################################################################################
#
# libsoundtouch
#
################################################################################

LIBSOUNDTOUCH_VERSION = 2.1.2
LIBSOUNDTOUCH_SITE = https://gitlab.com/soundtouch/soundtouch/-/archive/$(LIBSOUNDTOUCH_VERSION)
LIBSOUNDTOUCH_LICENSE = LGPL-2.1+
LIBSOUNDTOUCH_LICENSE_FILES = COPYING.TXT
LIBSOUNDTOUCH_AUTORECONF = YES
LIBSOUNDTOUCH_INSTALL_STAGING = YES

$(eval $(autotools-package))
