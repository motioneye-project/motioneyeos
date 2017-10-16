################################################################################
#
# automake
#
################################################################################

AUTOMAKE_VERSION = 1.15.1
AUTOMAKE_SOURCE = automake-$(AUTOMAKE_VERSION).tar.xz
AUTOMAKE_SITE = $(BR2_GNU_MIRROR)/automake
AUTOMAKE_LICENSE = GPL-2.0+
AUTOMAKE_LICENSE_FILES = COPYING

HOST_AUTOMAKE_DEPENDENCIES = host-autoconf

ACLOCAL_HOST_DIR = $(HOST_DIR)/share/aclocal

define GTK_DOC_M4_INSTALL
	$(INSTALL) -D -m 0644 package/automake/gtk-doc.m4 \
		$(ACLOCAL_HOST_DIR)/gtk-doc.m4
endef

# ensure staging aclocal dir exists
define HOST_AUTOMAKE_MAKE_ACLOCAL
	mkdir -p $(ACLOCAL_DIR)
endef

HOST_AUTOMAKE_POST_INSTALL_HOOKS += GTK_DOC_M4_INSTALL
HOST_AUTOMAKE_POST_INSTALL_HOOKS += HOST_AUTOMAKE_MAKE_ACLOCAL

$(eval $(host-autotools-package))

# variables used by other packages
AUTOMAKE = $(HOST_DIR)/bin/automake
ACLOCAL_DIR = $(STAGING_DIR)/usr/share/aclocal
ACLOCAL = $(HOST_DIR)/bin/aclocal -I $(ACLOCAL_DIR)
