CLOOP_VERSION=2.631-1
CLOOP_SOURCE=cloop_$(CLOOP_VERSION).tar.gz
CLOOP_SITE=http://debian-knoppix.alioth.debian.org/sources/

HOST_CLOOP_DEPENDENCIES = host-zlib

define HOST_CLOOP_BUILD_CMDS
 $(HOST_MAKE_ENV) $(MAKE1) \
   CFLAGS="$(HOST_CFLAGS) -Wall -O2 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -DUSE_ERROR_SILENT" -C $(@D) APPSONLY=yes
endef

define HOST_CLOOP_INSTALL_CMDS
 install -m 755 $(@D)/create_compressed_fs $(HOST_DIR)/usr/bin
 install -m 755 $(@D)/extract_compressed_fs $(HOST_DIR)/usr/bin
endef

$(eval $(call GENTARGETS,package,cloop))
$(eval $(call GENTARGETS,package,cloop,host))