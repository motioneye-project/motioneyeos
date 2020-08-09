################################################################################
#
# libiscsi
#
################################################################################

LIBISCSI_VERSION = 1.19.0
LIBISCSI_SITE = $(call github,sahlberg,libiscsi,$(LIBISCSI_VERSION))
LIBISCSI_LICENSE = GPL-2.0+, LGPL-2.1+
LIBISCSI_LICENSE_FILES = COPYING LICENCE-GPL-2.txt LICENCE-LGPL-2.1.txt
LIBISCSI_INSTALL_STAGING = YES
LIBISCSI_AUTORECONF = YES

LIBISCSI_CONF_OPTS = --disable-examples --disable-werror --disable-manpages \
	--disable-test-tool --disable-tests

$(eval $(autotools-package))
