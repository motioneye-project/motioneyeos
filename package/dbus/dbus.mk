#############################################################
#
# dbus
#
#############################################################
DBUS_VERSION = 1.2.16
DBUS_SOURCE = dbus-$(DBUS_VERSION).tar.gz
DBUS_SITE = http://dbus.freedesktop.org/releases/dbus/
DBUS_LIBTOOL_PATCH = NO
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

$(eval $(call AUTOTARGETS,package,dbus))

# fix rebuild if /var/lib is a symlink to /tmp
$(DBUS_HOOK_POST_BUILD): $(DBUS_TARGET_BUILD)
	rm -rf /tmp/dbus
	touch $@

$(DBUS_HOOK_POST_INSTALL): $(DBUS_TARGET_INSTALL_TARGET)
	rm -rf $(TARGET_DIR)/usr/lib/dbus-1.0
	rm -rf $(TARGET_DIR)/var/lib/dbus
	ln -sf /tmp/dbus $(TARGET_DIR)/var/lib/dbus
	$(INSTALL) -m 0755 package/dbus/S30dbus $(TARGET_DIR)/etc/init.d
	touch $@

# dbus for the host
DBUS_HOST_DIR:=$(BUILD_DIR)/dbus-$(DBUS_VERSION)-host
DBUS_HOST_INTROSPECT:=$(DBUS_HOST_DIR)/introspect.xml

$(DL_DIR)/$(DBUS_SOURCE):
	$(call DOWNLOAD,$(DBUS_SITE),$(DBUS_SOURCE))

$(STAMP_DIR)/host_dbus_unpacked: $(DL_DIR)/$(DBUS_SOURCE)
	mkdir -p $(DBUS_HOST_DIR)
	$(INFLATE$(suffix $(DBUS_SOURCE))) $< | \
		$(TAR) $(TAR_STRIP_COMPONENTS)=1 -C $(DBUS_HOST_DIR) $(TAR_OPTIONS) -
	touch $@

$(STAMP_DIR)/host_dbus_configured: $(STAMP_DIR)/host_dbus_unpacked $(STAMP_DIR)/host_expat_installed $(STAMP_DIR)/host_pkgconfig_installed
	(cd $(DBUS_HOST_DIR); rm -rf config.cache; \
		$(HOST_CONFIGURE_OPTS) \
		CFLAGS="$(HOST_CFLAGS)" \
		LDFLAGS="$(HOST_LDFLAGS)" \
		./configure \
		--prefix="$(HOST_DIR)/usr" \
		--sysconfdir="$(HOST_DIR)/etc" \
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

$(STAMP_DIR)/host_dbus_compiled: $(STAMP_DIR)/host_dbus_configured
	$(HOST_MAKE_ENV) $(MAKE) -C $(DBUS_HOST_DIR)
	touch $@

$(STAMP_DIR)/host_dbus_installed: $(STAMP_DIR)/host_dbus_compiled
	$(MAKE) -C $(DBUS_HOST_DIR) install
	$(HOST_DIR)/usr/bin/dbus-daemon --introspect > $(DBUS_HOST_INTROSPECT)
	touch $@

host-dbus: $(STAMP_DIR)/host_dbus_installed

host-dbus-source: dbus-source

host-dbus-clean:
	rm -f $(addprefix $(STAMP_DIR)/host_dbus_,unpacked configured compiled installed)
	rm -f $(DBUS_HOST_INTROSPECT)
	-$(MAKE) -C $(DBUS_HOST_DIR) uninstall
	-$(MAKE) -C $(DBUS_HOST_DIR) clean

host-dbus-dirclean:
	rm -rf $(DBUS_HOST_DIR)
