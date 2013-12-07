################################################################################
#
# liblockfile
#
################################################################################

LIBLOCKFILE_VERSION = 1.08
LIBLOCKFILE_SOURCE = liblockfile_$(LIBLOCKFILE_VERSION).orig.tar.gz
LIBLOCKFILE_SITE = $(BR2_DEBIAN_MIRROR)/debian/pool/main/libl/liblockfile/
LIBLOCKFILE_PATCH = liblockfile_$(LIBLOCKFILE_VERSION)-4.debian.tar.bz2

LIBLOCKFILE_LICENSE = LGPLv2+, dotlockfile GPLv2+
# No license file included, it refers to the gnu.org website

LIBLOCKFILE_INSTALL_STAGING = YES
LIBLOCKFILE_CONF_OPT = --mandir=/usr/share/man

define LIBLOCKFILE_INSTALL_STAGING_CMDS
	mkdir -p $(addprefix $(STAGING_DIR)/usr/share/man/man,1 3)
	rm -f $(STAGING_DIR)/usr/lib/liblockfile.so
	$(MAKE) -C $(LIBLOCKFILE_DIR) ROOT=$(STAGING_DIR) install
	ln -sf liblockfile.so $(STAGING_DIR)/usr/lib/liblockfile.so.1
endef

define LIBLOCKFILE_INSTALL_TARGET_CMDS
	cp -a $(STAGING_DIR)/usr/lib/liblockfile.so* $(TARGET_DIR)/usr/lib
endef

$(eval $(autotools-package))
