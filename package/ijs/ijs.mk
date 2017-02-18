################################################################################
#
# ijs
#
################################################################################

IJS_VERSION = 0.35
IJS_SOURCE = ijs-$(IJS_VERSION).tar.bz2
IJS_SITE = http://www.openprinting.org/download/ijs/download
IJS_LICENSE = MIT
IJS_LICENSE_FILES = README
# Buildroot libtool patch does not apply, so we autoreconf the
# package.
IJS_AUTORECONF = YES
IJS_INSTALL_STAGING = YES

$(eval $(autotools-package))
