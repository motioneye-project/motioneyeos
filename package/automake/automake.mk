################################################################################
#
# automake
#
################################################################################

AUTOMAKE_VERSION = 1.11.6
AUTOMAKE_SITE = $(BR2_GNU_MIRROR)/automake
AUTOMAKE_LICENSE = GPLv2+
AUTOMAKE_LICENSE_FILES = COPYING

AUTOMAKE_DEPENDENCIES = host-autoconf autoconf perl

HOST_AUTOMAKE_DEPENDENCIES = host-autoconf

define GTK_DOC_M4_INSTALL
 $(INSTALL) -D -m 0644 package/automake/gtk-doc.m4 $(HOST_DIR)/usr/share/aclocal/gtk-doc.m4
endef

# ensure staging aclocal dir exists
define HOST_AUTOMAKE_MAKE_ACLOCAL
	mkdir -p $(ACLOCAL_DIR)
endef

HOST_AUTOMAKE_POST_INSTALL_HOOKS += GTK_DOC_M4_INSTALL
HOST_AUTOMAKE_POST_INSTALL_HOOKS += HOST_AUTOMAKE_MAKE_ACLOCAL

$(eval $(autotools-package))
$(eval $(host-autotools-package))

# variables used by other packages
AUTOMAKE = $(HOST_DIR)/usr/bin/automake
ACLOCAL_DIR = $(STAGING_DIR)/usr/share/aclocal
ACLOCAL_HOST_DIR = $(HOST_DIR)/usr/share/aclocal
ACLOCAL = $(HOST_DIR)/usr/bin/aclocal -I $(ACLOCAL_DIR)
