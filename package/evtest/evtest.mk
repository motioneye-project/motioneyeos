################################################################################
#
# evtest
#
################################################################################

EVTEST_VERSION = 1.30
EVTEST_SOURCE = evtest-$(EVTEST_VERSION).tar.bz2
# no official upstream tarball
EVTEST_SITE = http://pkgs.fedoraproject.org/repo/pkgs/evtest/evtest-1.30.tar.bz2/27c0902839babfd07136f232c63c895c/
EVTEST_LICENSE = GPLv2
EVTEST_LICENSE_FILES = COPYING
EVTEST_DEPENDENCIES = host-pkgconf

ifeq ($(BR2_PACKAGE_EVTEST_CAPTURE),y)
EVTEST_DEPENDENCIES += libxml2
else
# evtest-capture will unconditionally be built/installed if libxml2 is present
define EVTEST_REMOVE_EVTEST_CAPTURE
	rm -rf $(TARGET_DIR)/usr/bin/evtest-capture \
	       $(TARGET_DIR)/usr/share/evtest \
	       $(TARGET_DIR)/usr/share/man/man1/evtest-capture.1
endef

EVTEST_POST_INSTALL_TARGET_HOOKS += EVTEST_REMOVE_EVTEST_CAPTURE
endif

$(eval $(autotools-package))
