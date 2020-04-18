################################################################################
#
# polkit
#
################################################################################

POLKIT_VERSION = 0.116
POLKIT_SITE = http://www.freedesktop.org/software/polkit/releases
POLKIT_LICENSE = GPL-2.0
POLKIT_LICENSE_FILES = COPYING
POLKIT_AUTORECONF = YES
POLKIT_INSTALL_STAGING = YES

POLKIT_DEPENDENCIES = \
	libglib2 host-intltool expat spidermonkey $(TARGET_NLS_DEPENDENCIES)

# spidermonkey needs C++11
POLKIT_CONF_ENV = \
	CXXFLAGS="$(TARGET_CXXFLAGS) -std=c++11" \
	LIBS=$(TARGET_NLS_LIBS)

POLKIT_CONF_OPTS = \
	--with-os-type=unknown \
	--disable-man-pages \
	--disable-examples \
	--disable-libelogind \
	--disable-libsystemd-login

ifeq ($(BR2_PACKAGE_GOBJECT_INTROSPECTION),y)
POLKIT_CONF_OPTS += --enable-introspection
POLKIT_DEPENDENCIES += gobject-introspection
else
POLKIT_CONF_OPTS += --disable-introspection
endif

ifeq ($(BR2_PACKAGE_LINUX_PAM),y)
POLKIT_DEPENDENCIES += linux-pam
POLKIT_CONF_OPTS += --with-authfw=pam
else
POLKIT_CONF_OPTS += --with-authfw=shadow
endif

define POLKIT_USERS
	polkitd -1 polkitd -1 * - - - Polkit Daemon
endef

define POLKIT_PERMISSIONS
	/etc/polkit-1 r 750 root polkitd - - - - -
	/usr/share/polkit-1 r 750 root polkitd - - - - -
	/usr/bin/pkexec f 4755 root root - - - - -
endef

define POLKIT_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 $(POLKIT_PKGDIR)/polkit.service \
		$(TARGET_DIR)/usr/lib/systemd/system/polkit.service

endef

$(eval $(autotools-package))
