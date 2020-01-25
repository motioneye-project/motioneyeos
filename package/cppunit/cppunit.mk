################################################################################
#
# cppunit
#
################################################################################

CPPUNIT_VERSION = 1.15.1
CPPUNIT_SITE = http://dev-www.libreoffice.org/src
CPPUNIT_INSTALL_STAGING = YES
CPPUNIT_LICENSE = LGPL-2.1
CPPUNIT_LICENSE_FILES = COPYING
CPPUNIT_CONF_OPTS = --disable-doxygen

$(eval $(autotools-package))
