################################################################################
#
# cloop
#
################################################################################

CLOOP_VERSION = 3.14.1.2
CLOOP_SOURCE = cloop_$(CLOOP_VERSION).tar.xz
CLOOP_SITE = http://snapshot.debian.org/archive/debian/20150503T155713Z/pool/main/c/cloop
CLOOP_LICENSE = GPL-2.0 (module), GPL-2.0+ (advancecomp)
CLOOP_LICENSE_FILES = README advancecomp-1.15/COPYING

HOST_CLOOP_DEPENDENCIES = host-zlib

define HOST_CLOOP_BUILD_CMDS
	$(HOST_CONFIGURE_OPTS) $(MAKE1) -C $(@D) APPSONLY=yes \
		CFLAGS="$(HOST_CFLAGS) -D_GNU_SOURCE"
endef

define HOST_CLOOP_INSTALL_CMDS
	$(INSTALL) -m 0755 -d $(HOST_DIR)/bin
	$(INSTALL) -m 755 $(@D)/create_compressed_fs $(HOST_DIR)/bin
	$(INSTALL) -m 755 $(@D)/extract_compressed_fs $(HOST_DIR)/bin
endef

$(eval $(host-generic-package))
