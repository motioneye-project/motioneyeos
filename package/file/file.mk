#############################################################
#
# file
#
#############################################################

FILE_VERSION = 5.04
FILE_SITE = ftp://ftp.astron.com/pub/file/
FILE_DEPENDENCIES = host-file zlib
HOST_FILE_DEPENDENCIES = host-zlib

define FILE_UNINSTALL_TARGET_CMDS
	$(MAKE) DESTDIR=$(TARGET_DIR) uninstall -C $(FILE_DIR)
	rm -f $(TARGET_DIR)/usr/lib/libmagic.*
endef

$(eval $(call AUTOTARGETS,package,file))
$(eval $(call AUTOTARGETS,package,file,host))
