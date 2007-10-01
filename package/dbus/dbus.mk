#############################################################
#
# dbus
#
#############################################################
DBUS_VERSION:=1.1.1
DBUS_SOURCE:=dbus-$(DBUS_VERSION).tar.gz
DBUS_SITE:=http://dbus.freedesktop.org/releases/dbus/
DBUS_DIR:=$(BUILD_DIR)/dbus-$(DBUS_VERSION)
DBUS_CAT:=$(ZCAT)
DBUS_BINARY:=bus/dbus-daemon
DBUS_TARGET_BINARY:=usr/bin/dbus-daemon

$(DL_DIR)/$(DBUS_SOURCE):
	$(WGET) -P $(DL_DIR) $(DBUS_SITE)/$(DBUS_SOURCE)

dbus-source: $(DL_DIR)/$(DBUS_SOURCE)

$(DBUS_DIR)/.unpacked: $(DL_DIR)/$(DBUS_SOURCE)
	$(DBUS_CAT) $(DL_DIR)/$(DBUS_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $@

$(DBUS_DIR)/.configured: $(DBUS_DIR)/.unpacked
	(cd $(DBUS_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		ac_cv_have_abstract_sockets=yes \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--localstatedir=/var \
		--program-prefix="" \
		--sysconfdir=/etc \
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
		--without-xml \
		--with-system-socket=/var/run/dbus/system_bus_socket \
		--with-system-pid-file=/var/run/messagebus.pid \
	)
	touch $@

$(DBUS_DIR)/$(DBUS_BINARY): $(DBUS_DIR)/.configured
	$(MAKE) DBUS_BUS_LIBS="$(STAGING_DIR)/usr/lib/libexpat.so $(STAGING_DIR)/usr/lib/libxml2.so" -C $(DBUS_DIR) all

$(STAGING_DIR)/usr/lib/libdbus-1.so: $(DBUS_DIR)/$(DBUS_BINARY)
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(DBUS_DIR)/dbus install

$(TARGET_DIR)/$(DBUS_TARGET_BINARY): $(STAGING_DIR)/usr/lib/libdbus-1.so
	mkdir -p $(TARGET_DIR)/var/run/dbus $(TARGET_DIR)/etc/init.d
	$(MAKE) DESTDIR=$(TARGET_DIR) -C $(DBUS_DIR)/dbus install
	rm -rf $(TARGET_DIR)/usr/lib/dbus-1.0
	rm -f $(TARGET_DIR)/usr/lib/libdbus-1.la \
		$(TARGET_DIR)/usr/lib/libdbus-1.so
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libdbus-1.so.3.2.0
	$(MAKE) DESTDIR=$(TARGET_DIR) initddir=/etc/init.d -C $(DBUS_DIR)/bus install
	$(INSTALL) -m 0755 package/dbus/S97messagebus $(TARGET_DIR)/etc/init.d
	rm -f $(TARGET_DIR)/etc/init.d/messagebus
	rm -rf $(TARGET_DIR)/usr/share/man
	rmdir --ignore-fail-on-non-empty $(TARGET_DIR)/usr/share
	rm -rf $(TARGET_DIR)/etc/rc.d

dbus: uclibc expat libxml2-headers $(TARGET_DIR)/$(DBUS_TARGET_BINARY)

dbus-clean:
	rm -f $(TARGET_DIR)/etc/dbus-1/session.conf
	rm -f $(TARGET_DIR)/etc/dbus-1/system.conf
	rmdir -p --ignore-fail-on-non-empty $(TARGET_DIR)/etc/dbus-1/system.d
	rm -f $(TARGET_DIR)/etc/init.d/S97messagebus
	rm -f $(TARGET_DIR)/usr/lib/libdbus-1.so*
	rm -f $(TARGET_DIR)/usr/bin/dbus-daemon
	rm -rf $(TARGET_DIR)/tmp/dbus
	rm -f $(STAGING_DIR)/usr/lib/libdbus-1.*
	rm -rf $(STAGING_DIR)/usr/lib/dbus-1.0
	rm -rf $(STAGING_DIR)/usr/include/dbus-1.0
	rmdir --ignore-fail-on-non-empty $(STAGING_DIR)/usr/include
	-$(MAKE) -C $(DBUS_DIR) clean

dbus-dirclean:
	rm -rf $(DBUS_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_DBUS)),y)
TARGETS+=dbus
endif
