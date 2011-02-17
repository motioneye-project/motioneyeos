#############################################################
#
# gvfs
#
#############################################################
GVFS_VERSION_MAJOR = 1.6
GVFS_VERSION_MINOR = 6
GVFS_VERSION = $(GVFS_VERSION_MAJOR).$(GVFS_VERSION_MINOR)
GVFS_SOURCE = gvfs-$(GVFS_VERSION).tar.gz
GVFS_SITE = http://ftp.gnome.org/pub/GNOME/sources/gvfs/$(GVFS_VERSION_MAJOR)
GVFS_INSTALL_STAGING = NO
GVFS_INSTALL_TARGET = YES
GVFS_AUTORECONF = NO
GVFS_DEPENDENCIES = host-pkg-config host-libglib2 libglib2 dbus-glib shared-mime-info

GVFS_CONF_OPT = \
	--disable-gconf			\
	--disable-cdda			\
	--disable-obexftp		\
	--disable-gphoto2		\
	--disable-keyring		\
	--disable-bash-completion	\

ifeq ($(BR2_PACKAGE_AVAHI),y)
GVFS_DEPENDENCIES += avahi
GVFS_CONF_OPT += --enable-avahi
else
GVFS_CONF_OPT += --disable-avahi
endif

ifeq ($(BR2_PACKAGE_HAL),y)
GVFS_DEPENDENCIES += hal
GVFS_CONF_OPT += --enable-hal
else
GVFS_CONF_OPT += --disable-hal
endif

ifeq ($(BR2_PACKAGE_LIBARCHIVE),y)
GVFS_DEPENDENCIES += libarchive
GVFS_CONF_OPT += --enable-archive
else
GVFS_CONF_OPT += --disable-archive
endif

ifeq ($(BR2_PACKAGE_LIBFUSE),y)
GVFS_DEPENDENCIES += libfuse
GVFS_CONF_OPT += --enable-fuse
else
GVFS_CONF_OPT += --disable-fuse
endif

ifeq ($(BR2_PACKAGE_LIBSOUP),y)
GVFS_DEPENDENCIES += libsoup
GVFS_CONF_OPT += --enable-http
else
GVFS_CONF_OPT += --disable-http
endif

ifeq ($(BR2_PACKAGE_SAMBA_LIBSMBCLIENT),y)
GVFS_DEPENDENCIES += samba
GVFS_CONF_OPT += \
	--enable-samba \
	--with-samba-includes=$(STAGING_DIR)/usr/include \
	--with-samba-libs=$(STAGING_DIR)/usr/lib \
	ac_cv_lib_smbclient_smbc_option_get=yes
else
GVFS_CONF_OPT += --disable-samba
endif

define GVFS_REMOVE_USELESS_BINARY
	rm $(TARGET_DIR)/usr/bin/gvfs-less
endef

GVFS_POST_INSTALL_TARGET_HOOKS += GVFS_REMOVE_USELESS_BINARY

$(eval $(call AUTOTARGETS,package,gvfs))
