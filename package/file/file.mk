################################################################################
#
# file
#
################################################################################

FILE_VERSION = 5.14
FILE_SITE = ftp://ftp.astron.com/pub/file
FILE_DEPENDENCIES = host-file zlib
FILE_INSTALL_STAGING = YES
FILE_LICENSE = BSD-2c, one file BSD-4c, one file BSD-3c
FILE_LICENSE_FILES = COPYING src/mygetopt.h src/vasprintf.c

define FILE_UNINSTALL_TARGET_CMDS
	$(MAKE) DESTDIR=$(TARGET_DIR) uninstall -C $(FILE_DIR)
	rm -f $(TARGET_DIR)/usr/lib/libmagic.*
endef

$(eval $(autotools-package))
$(eval $(host-autotools-package))
