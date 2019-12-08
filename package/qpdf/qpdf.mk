################################################################################
#
# qpdf
#
################################################################################

QPDF_VERSION = 8.4.0
QPDF_SITE = http://downloads.sourceforge.net/project/qpdf/qpdf/$(QPDF_VERSION)
QPDF_INSTALL_STAGING = YES
QPDF_LICENSE = Apache-2.0 or Artistic-2.0
QPDF_LICENSE_FILES = LICENSE.txt Artistic-2.0
QPDF_DEPENDENCIES = zlib jpeg

QPDF_CONF_OPTS = --without-random

$(eval $(autotools-package))
