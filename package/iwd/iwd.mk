################################################################################
#
# iwd
#
################################################################################

IWD_VERSION = 0.22
IWD_SITE = https://git.kernel.org/pub/scm/network/wireless/iwd.git
IWD_SITE_METHOD = git
IWD_LICENSE = LGPL-2.1+
IWD_LICENSE_FILES = COPYING
# sources from git, no configure script provided
IWD_AUTORECONF = YES

IWD_CONF_OPTS = \
	--disable-manual-pages \
	--enable-external-ell
IWD_DEPENDENCIES = ell

# autoreconf requires an existing build-aux directory
define IWD_MKDIR_BUILD_AUX
	mkdir -p $(@D)/build-aux
endef
IWD_POST_PATCH_HOOKS += IWD_MKDIR_BUILD_AUX

ifeq ($(BR2_PACKAGE_DBUS),y)
IWD_CONF_OPTS += --enable-dbus-policy --with-dbus-datadir=/usr/share
IWD_DEPENDENCIES += dbus
else
IWD_CONF_OPTS += --disable-dbus-policy
endif

ifeq ($(BR2_PACKAGE_READLINE),y)
# iwd client depends on readline (GPL-3.0+)
IWD_LICENSE += , GPL-3.0+ (client)
IWD_CONF_OPTS += --enable-client
IWD_DEPENDENCIES += readline
else
IWD_CONF_OPTS += --disable-client
endif

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
IWD_CONF_OPTS += --enable-systemd-service
IWD_DEPENDENCIES += systemd
else
IWD_CONF_OPTS += --disable-systemd-service
endif

$(eval $(autotools-package))
