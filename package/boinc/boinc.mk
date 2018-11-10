################################################################################
#
# boinc
#
################################################################################

BOINC_VERSION_MAJOR = 7.8
BOINC_VERSION = $(BOINC_VERSION_MAJOR).6
# client_release can be used to build the Client and Manager but not the Server
# part. The Server currently has no versioning (see
# https://github.com/BOINC/boinc/pull/1798).
BOINC_SITE = \
	$(call github,BOINC,boinc,client_release/$(BOINC_VERSION_MAJOR)/$(BOINC_VERSION))
BOINC_LICENSE = LGPL-3.0+
BOINC_LICENSE_FILES = COPYING COPYING.LESSER
BOINC_DEPENDENCIES = host-pkgconf libcurl openssl
BOINC_AUTORECONF = YES
BOINC_CONF_OPTS = \
	--disable-apps \
	--disable-boinczip \
	--disable-manager \
	--disable-server \
	--enable-client \
	--enable-dynamic-client-linkage \
	--enable-libraries \
	--with-pkg-config=$(PKG_CONFIG_HOST_BINARY) \
	--with-libcurl=$(STAGING_DIR)/usr

ifeq ($(BR2_PACKAGE_FREETYPE),y)
BOINC_DEPENDENCIES += freetype
endif

ifeq ($(BR2_PACKAGE_LIBFCGI),y)
BOINC_DEPENDENCIES += libfcgi
BOINC_CONF_OPTS += --enable-fcgi
else
BOINC_CONF_OPTS += --disable-fcgi
endif

# Remove boinc-client because it is incompatible with buildroot
define BOINC_REMOVE_UNNEEDED_FILE
	$(RM) $(TARGET_DIR)/etc/init.d/boinc-client
endef

BOINC_POST_INSTALL_TARGET_HOOKS += BOINC_REMOVE_UNNEEDED_FILE

define BOINC_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/boinc/S99boinc-client \
		$(TARGET_DIR)/etc/init.d/S99boinc-client
endef

define BOINC_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/boinc/boinc-client.service \
		$(TARGET_DIR)/usr/lib/systemd/system/boinc-client.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -sf ../../../../usr/lib/systemd/system/boinc-client.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/boinc-client.service
endef

$(eval $(autotools-package))
