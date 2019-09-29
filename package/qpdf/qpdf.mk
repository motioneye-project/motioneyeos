################################################################################
#
# qpdf
#
################################################################################

QPDF_VERSION = 8.2.1
QPDF_SITE = http://downloads.sourceforge.net/project/qpdf/qpdf/$(QPDF_VERSION)
QPDF_INSTALL_STAGING = YES
QPDF_LICENSE = Artistic-2.0
QPDF_LICENSE_FILES = Artistic-2.0
QPDF_DEPENDENCIES = pcre zlib jpeg

QPDF_CONF_OPTS = --without-random

$(eval $(autotools-package))
