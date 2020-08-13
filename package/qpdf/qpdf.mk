################################################################################
#
# qpdf
#
################################################################################

QPDF_VERSION = 9.1.1
QPDF_SITE = http://downloads.sourceforge.net/project/qpdf/qpdf/$(QPDF_VERSION)
QPDF_INSTALL_STAGING = YES
QPDF_LICENSE = Apache-2.0 or Artistic-2.0
QPDF_LICENSE_FILES = LICENSE.txt Artistic-2.0
QPDF_DEPENDENCIES = host-pkgconf zlib jpeg

QPDF_CONF_OPTS = --with-random=/dev/urandom

ifeq ($(BR2_PACKAGE_GNUTLS),y)
QPDF_CONF_OPTS += --enable-crypto-gnutls
QPDF_DEPENDENCIES += gnutls
else
QPDF_CONF_OPTS += --disable-crypto-gnutls
endif

$(eval $(autotools-package))
