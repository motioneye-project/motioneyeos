################################################################################
#
# cppunit
#
################################################################################

CPPUNIT_VERSION = 1.13.2
CPPUNIT_SITE = http://dev-www.libreoffice.org/src
CPPUNIT_INSTALL_STAGING = YES
CPPUNIT_LICENSE = LGPLv2.1
CPPUNIT_LICENSE_FILES = COPYING
CPPUNIT_CONF_OPTS = --disable-doxygen

$(eval $(autotools-package))
