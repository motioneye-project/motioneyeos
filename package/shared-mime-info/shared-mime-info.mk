################################################################################
#
# shared-mime-info
#
################################################################################

SHARED_MIME_INFO_VERSION = 0.90
SHARED_MIME_INFO_SOURCE = shared-mime-info-$(SHARED_MIME_INFO_VERSION).tar.bz2
SHARED_MIME_INFO_SITE = http://freedesktop.org/~hadess
SHARED_MIME_INFO_INSTALL_STAGING = YES
SHARED_MIME_INFO_CONF_ENV = XMLLINT=$(HOST_DIR)/usr/bin/xmllint
SHARED_MIME_INFO_DEPENDENCIES = host-shared-mime-info libxml2 libglib2
SHARED_MIME_INFO_CONF_OPTS = --disable-update-mimedb
SHARED_MIME_INFO_MAKE = $(MAKE1)
SHARED_MIME_INFO_LICENSE = GPLv2
SHARED_MIME_INFO_LICENSE_FILES = COPYING

HOST_SHARED_MIME_INFO_DEPENDENCIES = \
	host-pkgconf host-intltool host-libxml2 host-libglib2

HOST_SHARED_MIME_INFO_CONF_OPTS = --disable-update-mimedb
HOST_SHARED_MIME_INFO_MAKE = $(MAKE1)

define SHARED_MIME_INFO_INSTALL_TARGET_CMDS
	$(HOST_MAKE_ENV) $(SHARED_MIME_INFO_HOST_BINARY) $(STAGING_DIR)/usr/share/mime
	$(INSTALL) -D $(STAGING_DIR)/usr/share/mime/mime.cache $(TARGET_DIR)/usr/share/mime/mime.cache
endef

$(eval $(autotools-package))
$(eval $(host-autotools-package))

# shared-mime-info for the host
SHARED_MIME_INFO_HOST_BINARY = $(HOST_DIR)/usr/bin/update-mime-database
