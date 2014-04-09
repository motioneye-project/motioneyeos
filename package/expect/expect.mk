################################################################################
#
# expect
#
################################################################################

EXPECT_VERSION = 5.45
EXPECT_SOURCE = expect$(EXPECT_VERSION).tar.gz
EXPECT_SITE = http://downloads.sourceforge.net/project/expect/Expect/$(EXPECT_VERSION)
EXPECT_LICENSE = Public domain
EXPECT_LICENSE_FILES = README

EXPECT_AUTORECONF = YES
EXPECT_DEPENDENCIES = tcl
EXPECT_CONF_OPT = --with-tcl=$(BUILD_DIR)/tcl-$(TCL_VERSION)/unix

# Since we don't want examples installed
EXPECT_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR)  install-binaries

$(eval $(autotools-package))
