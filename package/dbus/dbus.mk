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

DBUS_DEPENDENCIES = uclibc host-pkgconfig

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

$(eval $(call AUTOTARGETS,package,dbus))

$(DBUS_HOOK_POST_INSTALL): $(DBUS_TARGET_INSTALL_TARGET)
	rm -rf $(TARGET_DIR)/usr/lib/dbus-1.0
	$(INSTALL) -m 0755 package/dbus/S30dbus $(TARGET_DIR)/etc/init.d
	touch $@

# dbus for the host
DBUS_HOST_DIR:=$(BUILD_DIR)/dbus-$(DBUS_VERSION)-host
DBUS_HOST_BINARY:=$(HOST_DIR)/usr/bin/dbus-daemon
DBUS_HOST_INTROSPECT:=$(DBUS_HOST_DIR)/introspect.xml

$(DBUS_HOST_DIR)/.unpacked: $(DL_DIR)/$(DBUS_SOURCE)
	mkdir -p $(@D)
	$(INFLATE$(suffix $(DBUS_SOURCE))) $< | \
		$(TAR) $(TAR_STRIP_COMPONENTS)=1 -C $(@D) $(TAR_OPTIONS) -
	touch $@

$(DBUS_HOST_DIR)/.configured: $(DBUS_HOST_DIR)/.unpacked $(EXPAT_HOST_BINARY)
	(cd $(@D); rm -rf config.cache; \
		$(HOST_CONFIGURE_OPTS) \
		CFLAGS="$(HOST_CFLAGS)" \
		LDFLAGS="$(HOST_LDFLAGS)" \
		$(@D)/configure \
		--prefix=$(HOST_DIR)/usr \
		--sysconfdir=$(HOST_DIR)/etc \
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
		--with-xml=expat \
	)
	touch $@

$(DBUS_HOST_DIR)/.compiled: $(DBUS_HOST_DIR)/.configured
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)
	touch $@

$(DBUS_HOST_BINARY): $(DBUS_HOST_DIR)/.compiled
	$(MAKE) -C $(<D) install

$(DBUS_HOST_INTROSPECT): $(DBUS_HOST_BINARY)
	$(DBUS_HOST_BINARY) --introspect > $@

host-dbus: $(DBUS_HOST_INTROSPECT)

host-dbus-source: dbus-source

host-dbus-clean:
	rm -f $(addprefix $(DBUS_HOST_DIR)/,.unpacked .configured .compiled)
	rm -f $(DBUS_HOST_INTROSPECT)
	$(MAKE) -C $(DBUS_HOST_DIR) uninstall
	$(MAKE) -C $(DBUS_HOST_DIR) clean

host-dbus-dirclean:
	rm -rf $(DBUS_HOST_DIR)
