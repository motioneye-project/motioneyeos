################################################################################
#
# shairport-sync
#
################################################################################

SHAIRPORT_SYNC_VERSION = 2.1.5
SHAIRPORT_SYNC_SITE = $(call github,mikebrady,shairport-sync,$(SHAIRPORT_SYNC_VERSION))

# Note: the COPYING file contains the text of GPLv3, but none of the
# code is under this license. Bug reported upstream at
# https://github.com/mikebrady/shairport-sync/issues/13.
SHAIRPORT_SYNC_LICENSE = MIT, BSD-3c
SHAIRPORT_SYNC_LICENSE_FILES = LICENSES
SHAIRPORT_SYNC_DEPENDENCIES = alsa-lib libdaemon popt
SHAIRPORT_SYNC_AUTORECONF = YES
SHAIRPORT_SYNC_CONF_OPTS = --with-alsa # required

# Avahi or tinysvcmdns (shaiport-sync bundles its own version of tinysvcmdns)
ifeq ($(BR2_PACKAGE_AVAHI),y)
SHAIRPORT_SYNC_DEPENDENCIES += avahi
SHAIRPORT_SYNC_CONF_OPTS += --with-avahi
else
SHAIRPORT_SYNC_CONF_OPTS += --with-tinysvcmdns
endif

# OpenSSL or PolarSSL
ifeq ($(BR2_PACKAGE_OPENSSL),y)
SHAIRPORT_SYNC_DEPENDENCIES += openssl
SHAIRPORT_SYNC_CONF_OPTS += --with-openssl
else
SHAIRPORT_SYNC_DEPENDENCIES += polarssl
SHAIRPORT_SYNC_CONF_OPTS += --with-polarssl
endif

ifeq ($(BR2_PACKAGE_SHAIRPORT_SYNC_LIBSOXR),y)
SHAIRPORT_SYNC_DEPENDENCIES += libsoxr
SHAIRPORT_SYNC_CONF_OPTS += --with-soxr
endif

define SHAIRPORT_SYNC_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/shairport-sync \
		$(TARGET_DIR)/usr/bin/shairport-sync
endef

define SHAIRPORT_SYNC_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/shairport-sync/S99shairport-sync \
		$(TARGET_DIR)/etc/init.d/S99shairport-sync
endef

$(eval $(autotools-package))
