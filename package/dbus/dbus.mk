#############################################################
#
# dbus
#
#############################################################
DBUS_VERSION = 1.2.12
DBUS_SOURCE = dbus-$(DBUS_VERSION).tar.gz
DBUS_SITE = http://dbus.freedesktop.org/releases/dbus/
DBUS_INSTALL_STAGING = YES
DBUS_INSTALL_TARGET = YES
ifeq ($(BR2_ENABLE_DEBUG),y)
# install-exec doesn't install the config file
DBUS_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install
else
# install-strip uses host strip
DBUS_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install-strip STRIPPROG="$(STRIPCMD)"
endif

DBUS_DEPENDENCIES = uclibc pkgconfig

ifeq ($(BR2_DBUS_EXPAT),y)
DBUS_XML:=expat
DBUS_DEPENDENCIES += expat
else
DBUS_XML:=libxml
DBUS_DEPENDENCIES += libxml2
endif

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
		--without-x \
		--with-xml=$(DBUS_XML) \
		--with-system-socket=/var/run/dbus/system_bus_socket \
		--with-system-pid-file=/var/run/messagebus.pid

$(eval $(call AUTOTARGETS,package,dbus))

$(DBUS_HOOK_POST_INSTALL): $(DBUS_TARGET_INSTALL_TARGET)
	rm -rf $(TARGET_DIR)/usr/lib/dbus-1.0
	$(INSTALL) -m 0755 package/dbus/S30dbus $(TARGET_DIR)/etc/init.d
	touch $@
