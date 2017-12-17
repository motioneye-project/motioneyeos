################################################################################
#
# gvfs
#
################################################################################

GVFS_VERSION_MAJOR = 1.30
GVFS_VERSION = $(GVFS_VERSION_MAJOR).3
GVFS_SOURCE = gvfs-$(GVFS_VERSION).tar.xz
GVFS_SITE = http://ftp.gnome.org/pub/GNOME/sources/gvfs/$(GVFS_VERSION_MAJOR)
GVFS_INSTALL_STAGING = YES
GVFS_DEPENDENCIES = host-pkgconf host-libglib2 libglib2 dbus shared-mime-info
GVFS_LICENSE = LGPLv2+
GVFS_LICENSE_FILES = COPYING

# Export ac_cv_path_LIBGCRYPT_CONFIG unconditionally to prevent
# build system from searching the host paths.
GVFS_CONF_ENV = ac_cv_path_LIBGCRYPT_CONFIG=$(STAGING_DIR)/usr/bin/libgcrypt-config

# Most of these are missing library support
GVFS_CONF_OPTS = \
	--disable-afc \
	--disable-admin \
	--disable-bash-completion \
	--disable-cdda \
	--disable-gconf \
	--disable-gcr \
	--disable-gdu \
	--disable-goa \
	--disable-google \
	--disable-gphoto2 \
	--disable-hal \
	--disable-keyring \
	--disable-libmtp \
	--disable-udisks2

ifeq ($(BR2_PACKAGE_AVAHI),y)
GVFS_DEPENDENCIES += avahi
GVFS_CONF_OPTS += --enable-avahi
else
GVFS_CONF_OPTS += --disable-avahi
endif

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
GVFS_DEPENDENCIES += udev
endif

ifeq ($(BR2_PACKAGE_LIBGUDEV),y)
GVFS_DEPENDENCIES += libgudev
endif

ifeq ($(BR2_PACKAGE_LIBARCHIVE),y)
GVFS_DEPENDENCIES += libarchive
GVFS_CONF_OPTS += \
	--enable-archive \
	--with-archive-includes=$(STAGING_DIR)/usr \
	--with-archive-libs=$(STAGING_DIR)/usr
else
GVFS_CONF_OPTS += --disable-archive
endif

ifeq ($(BR2_PACKAGE_LIBBLURAY),y)
GVFS_DEPENDENCIES += libbluray
GVFS_CONF_OPTS += --enable-bluray
else
GVFS_CONF_OPTS += --disable-bluray
endif

ifeq ($(BR2_PACKAGE_LIBFUSE),y)
GVFS_DEPENDENCIES += libfuse
GVFS_CONF_OPTS += --enable-fuse
else
GVFS_CONF_OPTS += --disable-fuse
endif

# AFP support is anon-only without libgcrypt which isn't very useful
ifeq ($(BR2_PACKAGE_LIBGCRYPT),y)
GVFS_CONF_OPTS += --enable-afp
GVFS_DEPENDENCIES += libgcrypt
else
GVFS_CONF_OPTS += --disable-afp
endif

ifeq ($(BR2_PACKAGE_LIBGTK3),y)
GVFS_CONF_OPTS += --enable-gtk
GVFS_DEPENDENCIES += libgtk3
else
GVFS_CONF_OPTS += --disable-gtk
endif

ifeq ($(BR2_PACKAGE_LIBNFS),y)
GVFS_CONF_OPTS += --enable-nfs
GVFS_DEPENDENCIES += libnfs
else
GVFS_CONF_OPTS += --disable-nfs
endif

ifeq ($(BR2_PACKAGE_LIBSOUP),y)
GVFS_DEPENDENCIES += libsoup
GVFS_CONF_OPTS += --enable-http
else
GVFS_CONF_OPTS += --disable-http
endif

ifeq ($(BR2_PACKAGE_SAMBA4),y)
GVFS_DEPENDENCIES += samba4
GVFS_CONF_OPTS += \
	--enable-samba \
	--with-samba-includes=$(STAGING_DIR)/usr/include/samba-4.0 \
	--with-samba-libs=$(STAGING_DIR)/usr/lib \
	ac_cv_lib_smbclient_smbc_option_get=yes
else
GVFS_CONF_OPTS += --disable-samba
endif

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
GVFS_DEPENDENCIES += systemd
else
GVFS_CONF_OPTS += --disable-libsystemd-login
endif

define GVFS_REMOVE_USELESS_BINARY
	rm $(TARGET_DIR)/usr/bin/gvfs-less
endef

define GVFS_REMOVE_TARGET_SCHEMAS
	rm $(TARGET_DIR)/usr/share/glib-2.0/schemas/*.xml
endef

define GVFS_COMPILE_SCHEMAS
	$(HOST_DIR)/usr/bin/glib-compile-schemas --targetdir=$(TARGET_DIR)/usr/share/glib-2.0/schemas $(STAGING_DIR)/usr/share/glib-2.0/schemas
endef

GVFS_POST_INSTALL_TARGET_HOOKS += \
	GVFS_REMOVE_USELESS_BINARY	\
	GVFS_REMOVE_TARGET_SCHEMAS	\
	GVFS_COMPILE_SCHEMAS

$(eval $(autotools-package))
