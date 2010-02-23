#############################################################
#
# automake
#
#############################################################
AUTOMAKE_VERSION = 1.10
AUTOMAKE_SOURCE = automake-$(AUTOMAKE_VERSION).tar.bz2
AUTOMAKE_SITE = $(BR2_GNU_MIRROR)/automake

ifeq ($(BR2_ENABLE_DEBUG),y) # install-exec doesn't install aclocal stuff
AUTOMAKE_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install
endif

AUTOMAKE_DEPENDENCIES = host-autoconf autoconf microperl

HOST_AUTOMAKE_DEPENDENCIES = host-autoconf

define GTK_DOC_M4_INSTALL
 $(INSTALL) -m 0644 package/automake/gtk-doc.m4 $(STAGING_DIR)/usr/share/aclocal/
endef

HOST_AUTOMAKE_POST_INSTALL_HOOKS += GTK_DOC_M4_INSTALL

$(eval $(call AUTOTARGETS,package,automake))
$(eval $(call AUTOTARGETS,package,automake,host))

# variables used by other packages
AUTOMAKE:=$(HOST_DIR)/usr/bin/automake
ACLOCAL_DIR = $(STAGING_DIR)/usr/share/aclocal
ACLOCAL = $(HOST_DIR)/usr/bin/aclocal -I $(ACLOCAL_DIR)
