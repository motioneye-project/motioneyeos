################################################################################
#
# fstrcmp
#
################################################################################

FSTRCMP_VERSION_MAJOR = 0.7
FSTRCMP_VERSION = $(FSTRCMP_VERSION_MAJOR).D001
FSTRCMP_SITE = https://sourceforge.net/projects/fstrcmp/files/fstrcmp/$(FSTRCMP_VERSION_MAJOR)
FSTRCMP_LICENSE = GPL-3.0+
FSTRCMP_LICENSE_FILES = LICENSE
FSTRCMP_INSTALL_STAGING = YES
FSTRCMP_DEPENDENCIES = host-libtool
FSTRCMP_CONF_ENV = LIBTOOL="$(HOST_DIR)/bin/libtool"

FSTRCMP_MAKE_OPTS = all-bin libdir/pkgconfig/fstrcmp.pc

# We need to install the package files ourselves due to upstream trying
# to install a .lai file which is missing because of rpath removal
define FSTRCMP_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) install-include
	$(INSTALL) -D -m 755 $(@D)/lib/.libs/libfstrcmp.a $(STAGING_DIR)/usr/lib/libfstrcmp.a
	$(INSTALL) -D -m 755 $(@D)/lib/libfstrcmp.la $(STAGING_DIR)/usr/lib/libfstrcmp.la
	$(INSTALL) -D -m 755 $(@D)/libdir/pkgconfig/fstrcmp.pc $(STAGING_DIR)/usr/lib/pkgconfig/fstrcmp.pc
endef

define FSTRCMP_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/bin/fstrcmp $(TARGET_DIR)/usr/bin/fstrcmp
endef

$(eval $(autotools-package))
