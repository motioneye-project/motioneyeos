################################################################################
#
# liblockfile
#
################################################################################

LIBLOCKFILE_VERSION = 1.09
LIBLOCKFILE_SOURCE = liblockfile_$(LIBLOCKFILE_VERSION).orig.tar.gz
LIBLOCKFILE_SITE = http://snapshot.debian.org/archive/debian/20151026T153523Z/pool/main/libl/liblockfile
LIBLOCKFILE_PATCH = liblockfile_$(LIBLOCKFILE_VERSION)-6.debian.tar.bz2

LIBLOCKFILE_LICENSE = LGPL-2.0+, GPL-2.0+ (dotlockfile)
LIBLOCKFILE_LICENSE_FILES = COPYRIGHT

LIBLOCKFILE_INSTALL_STAGING = YES
LIBLOCKFILE_CONF_OPTS = --mandir=/usr/share/man

define LIBLOCKFILE_INSTALL_STAGING_CMDS
	mkdir -p $(addprefix $(STAGING_DIR)/usr/share/man/man,1 3)
	rm -f $(STAGING_DIR)/usr/lib/liblockfile.so
	$(TARGET_MAKE_ENV) $(MAKE) -C $(LIBLOCKFILE_DIR) ROOT=$(STAGING_DIR) install
	ln -sf liblockfile.so $(STAGING_DIR)/usr/lib/liblockfile.so.1
endef

define LIBLOCKFILE_INSTALL_TARGET_CMDS
	cp -a $(STAGING_DIR)/usr/lib/liblockfile.so* $(TARGET_DIR)/usr/lib
endef

$(eval $(autotools-package))
