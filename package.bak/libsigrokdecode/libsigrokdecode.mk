################################################################################
#
# libsigrokdecode
#
################################################################################

LIBSIGROKDECODE_VERSION = 0.4.1
LIBSIGROKDECODE_SITE = http://sigrok.org/download/source/libsigrokdecode
LIBSIGROKDECODE_LICENSE = GPLv3+
LIBSIGROKDECODE_LICENSE_FILES = COPYING
LIBSIGROKDECODE_INSTALL_STAGING = YES
LIBSIGROKDECODE_DEPENDENCIES = host-pkgconf libglib2 python3

$(eval $(autotools-package))
