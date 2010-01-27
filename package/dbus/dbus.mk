#############################################################
#
# dbus
#
#############################################################
DBUS_VERSION = 1.2.16
DBUS_SOURCE = dbus-$(DBUS_VERSION).tar.gz
DBUS_SITE = http://dbus.freedesktop.org/releases/dbus/
DBUS_LIBTOOL_PATCH = NO
HOST_DBUS_LIBTOOL_PATCH = NO
DBUS_INSTALL_STAGING = YES
DBUS_INSTALL_TARGET = YES
ifeq ($(BR2_ENABLE_DEBUG),y)
# install-exec doesn't install the config file
DBUS_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install
else
# install-strip uses host strip
DBUS_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install-strip STRIPPROG="$(STRIPCMD)"
endif

DBUS_DEPENDENCIES = host-pkg-config

DBUS_CONF_ENV = ac_cv_have_abstract_sockets=yes
DBUS_CONF_OPT = --program-prefix="" \
		--with-dbus-user=dbus \
		--disable-tests \
		--disable-asserts \
		--enable-abstract-sockets \
		--disable-selinux \
		--disable-xml-docs \
		--disable-doxygen-docs \
		--disable-static \
		--enable-dnotify \
		--localstatedir=/var \
		--with-system-socket=/var/run/dbus/system_bus_socket \
		--with-system-pid-file=/var/run/messagebus.pid

ifeq ($(BR2_DBUS_EXPAT),y)
DBUS_CONF_OPT += --with-xml=expat
DBUS_DEPENDENCIES += expat
else
DBUS_CONF_OPT += --with-xml=libxml
DBUS_DEPENDENCIES += libxml2
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBX11),y)
DBUS_CONF_OPT += --with-x
DBUS_DEPENDENCIES += xlib_libX11
else
DBUS_CONF_OPT += --without-x
endif

HOST_DBUS_DEPENDENCIES = host-pkg-config host-expat
HOST_DBUS_CONF_OPT = \
		--with-dbus-user=dbus \
		--disable-tests \
		--disable-asserts \
		--enable-abstract-sockets \
		--disable-selinux \
		--disable-xml-docs \
		--disable-doxygen-docs \
		--disable-static \
		--enable-dnotify \
		--without-x \
		--with-xml=expat

# dbus for the host
DBUS_HOST_INTROSPECT=$(HOST_DBUS_DIR)/introspect.xml

HOST_DBUS_GEN_INTROSPECT = \
	$(HOST_DIR)/usr/bin/dbus-daemon --introspect > $(DBUS_HOST_INTROSPECT)

HOST_DBUS_POST_INSTALL_HOOKS += HOST_DBUS_GEN_INTROSPECT

$(eval $(call AUTOTARGETS,package,dbus))
$(eval $(call AUTOTARGETS,package,dbus,host))

# fix rebuild (dbus makefile errors out if /var/lib/dbus is a symlink)
$(DBUS_HOOK_POST_BUILD): $(DBUS_TARGET_BUILD)
	rm -rf $(TARGET_DIR)/var/lib/dbus
	touch $@

$(DBUS_HOOK_POST_INSTALL): $(DBUS_TARGET_INSTALL_TARGET)
ifneq ($(BR2_HAVE_DEVFILES),y)
	rm -rf $(TARGET_DIR)/usr/lib/dbus-1.0
endif
	rm -rf $(TARGET_DIR)/var/lib/dbus
	ln -sf /tmp/dbus $(TARGET_DIR)/var/lib/dbus
	$(INSTALL) -m 0755 package/dbus/S30dbus $(TARGET_DIR)/etc/init.d
	touch $@
