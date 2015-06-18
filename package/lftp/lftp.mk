################################################################################
#
# lftp
#
################################################################################

LFTP_VERSION = 4.6.3a
LFTP_SOURCE = lftp-$(LFTP_VERSION).tar.xz
LFTP_SITE = http://lftp.yar.ru/ftp
LFTP_LICENSE = GPLv3+
LFTP_LICENSE_FILES = COPYING
# Needed so that our libtool patch applies properly
LFTP_AUTORECONF = YES
LFTP_DEPENDENCIES = readline zlib host-pkgconf

ifneq ($(BR2_STATIC_LIBS),y)
LFTP_CONF_OPTS += --with-modules
endif

ifeq ($(BR2_PACKAGE_GNUTLS),y)
LFTP_DEPENDENCIES += gnutls
LFTP_CONF_OPTS += --with-gnutls
else
LFTP_CONF_OPTS += --without-gnutls
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
LFTP_DEPENDENCIES += openssl
LFTP_CONF_OPTS += --with-openssl
else
LFTP_CONF_OPTS += --without-openssl
endif

# Remove /usr/share/lftp
define LFTP_REMOVE_DATA
	$(RM) -fr $(TARGET_DIR)/usr/share/lftp
endef

LFTP_POST_INSTALL_TARGET_HOOKS += LFTP_REMOVE_DATA

# Optional commands and protocols
LFTP_MODULES_TO_REMOVE-$(BR2_PACKAGE_LFTP_CMD_MIRROR) += cmd-mirror.so
LFTP_MODULES_TO_REMOVE-$(BR2_PACKAGE_LFTP_CMD_SLEEP) += cmd-sleep.so
LFTP_MODULES_TO_REMOVE-$(BR2_PACKAGE_LFTP_CMD_TORRENT) += cmd-torrent.so
LFTP_MODULES_TO_REMOVE-$(BR2_PACKAGE_LFTP_PROTO_FISH) += proto-fish.so
LFTP_MODULES_TO_REMOVE-$(BR2_PACKAGE_LFTP_PROTO_FTP) += proto-ftp.so
LFTP_MODULES_TO_REMOVE-$(BR2_PACKAGE_LFTP_PROTO_HTTP) += proto-http.so
LFTP_MODULES_TO_REMOVE-$(BR2_PACKAGE_LFTP_PROTO_SFTP) += proto-sftp.so

define LFTP_REMOVE_MODULES
	for f in $(LFTP_MODULES_TO_REMOVE-) ; do \
		$(RM) -f $(TARGET_DIR)/usr/lib/lftp/$(LFTP_VERSION)/$$f ; \
	done
endef

LFTP_POST_INSTALL_TARGET_HOOKS += LFTP_REMOVE_MODULES

$(eval $(autotools-package))
