#############################################################
#
# file
#
#############################################################

FILE_VERSION = 5.04
FILE_SITE = ftp://ftp.astron.com/pub/file/
FILE_CONF_ENV = CFLAGS="$(TARGET_CFLAGS) -D_GNU_SOURCE"
FILE_DEPENDENCIES = host-file zlib
HOST_FILE_DEPENDENCIES = host-zlib

$(eval $(call AUTOTARGETS,package,file))
$(eval $(call AUTOTARGETS,package,file,host))

$(FILE_TARGET_UNINSTALL):
	$(call MESSAGE,"Uninstalling")
	$(MAKE) DESTDIR=$(TARGET_DIR) uninstall -C $(FILE_DIR)
	rm -f $(TARGET_DIR)/usr/lib/libmagic.*
	rm -f $(FILE_TARGET_INSTALL_TARGET) $(FILE_HOOK_POST_INSTALL)
