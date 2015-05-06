################################################################################
#
# expect
#
################################################################################

# Version 5.45.3
EXPECT_VERSION = 2014-05-02
EXPECT_SITE = cvs://expect.cvs.sourceforge.net:/cvsroot/expect
EXPECT_LICENSE = Public domain
EXPECT_LICENSE_FILES = README

EXPECT_AUTORECONF = YES
EXPECT_DEPENDENCIES = tcl
EXPECT_CONF_OPTS = --with-tcl=$(BUILD_DIR)/tcl-$(TCL_VERSION)/unix

# Since we don't want examples installed
EXPECT_INSTALL_TARGET_OPTS = DESTDIR=$(TARGET_DIR)  install-binaries

$(eval $(autotools-package))
