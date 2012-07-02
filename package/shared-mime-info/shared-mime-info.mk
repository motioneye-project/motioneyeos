#############################################################
#
# shared-mime-info
#
#############################################################
SHARED_MIME_INFO_VERSION = 0.90
SHARED_MIME_INFO_SOURCE = shared-mime-info-$(SHARED_MIME_INFO_VERSION).tar.bz2
SHARED_MIME_INFO_SITE = http://freedesktop.org/~hadess

SHARED_MIME_INFO_INSTALL_STAGING = YES

SHARED_MIME_INFO_CONF_ENV = XMLLINT=$(HOST_DIR)/usr/bin/xmllint
SHARED_MIME_INFO_DEPENDENCIES = host-pkg-config host-libglib2 host-libxml2 host-shared-mime-info libxml2 libglib2

SHARED_MIME_INFO_CONF_OPT = --disable-update-mimedb
SHARED_MIME_INFO_MAKE = $(MAKE1)

HOST_SHARED_MIME_INFO_DEPENDENCIES = host-pkg-config host-intltool

HOST_SHARED_MIME_INFO_CONF_OPT = --disable-update-mimedb
HOST_SHARED_MIME_INFO_MAKE = $(MAKE1)

define SHARED_MIME_INFO_INSTALL_TARGET_CMDS
	$(HOST_MAKE_ENV) $(SHARED_MIME_INFO_HOST_BINARY) $(STAGING_DIR)/usr/share/mime
	$(INSTALL) -D $(STAGING_DIR)/usr/share/mime/mime.cache $(TARGET_DIR)/usr/share/mime/mime.cache
endef

$(eval $(autotools-package))
$(eval $(host-autotools-package))

# shared-mime-info for the host
SHARED_MIME_INFO_HOST_BINARY:=$(HOST_DIR)/usr/bin/update-mime-database
