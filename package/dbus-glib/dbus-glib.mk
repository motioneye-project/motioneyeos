#############################################################
#
# dbus-glib
#
#############################################################
DBUS_GLIB_VERSION:=0.72
DBUS_GLIB_SOURCE:=dbus-glib-$(DBUS_GLIB_VERSION).tar.gz
DBUS_GLIB_SITE:=http://dbus.freedesktop.org/releases/dbus-glib/
DBUS_GLIB_DIR:=$(BUILD_DIR)/dbus-glib-$(DBUS_GLIB_VERSION)
DBUS_GLIB_CAT:=$(ZCAT)
DBUS_GLIB_BINARY:=dbus/.libs/dbus-binding-tool
DBUS_GLIB_TARGET_BINARY:=usr/bin/dbus-binding-tool

$(DL_DIR)/$(DBUS_GLIB_SOURCE):
	$(WGET) -P $(DL_DIR) $(DBUS_GLIB_SITE)/$(DBUS_GLIB_SOURCE)

dbus-glib-source: $(DL_DIR)/$(DBUS_GLIB_SOURCE)

$(DBUS_GLIB_DIR)/.unpacked: $(DL_DIR)/$(DBUS_GLIB_SOURCE)
	$(DBUS_GLIB_CAT) $(DL_DIR)/$(DBUS_GLIB_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(DBUS_GLIB_DIR) package/dbus-glib/ \*.patch
	touch $(DBUS_GLIB_DIR)/.unpacked

$(DBUS_GLIB_DIR)/.configured: $(DBUS_GLIB_DIR)/.unpacked
	(cd $(DBUS_GLIB_DIR); rm -rf config.cache; autoconf; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		ac_cv_have_abstract_sockets=yes \
		ac_cv_func_posix_getpwnam_r=yes \
		have_abstract_sockets=yes \
		DBUS_CFLAGS="-I$(STAGING_DIR)/usr/include/dbus-1.0 -I$(STAGING_DIR)/usr/lib/dbus-1.0/include" \
		DBUS_LIBS="$(STAGING_DIR)/usr/lib/libdbus-1.so" \
		DBUS_GLIB_CFLAGS="-I$(STAGING_DIR)/usr/include/glib-2.0 -I$(STAGING_DIR)/usr/lib/glib-2.0/include" \
		DBUS_GLIB_LIBS="$(STAGING_DIR)/lib/libglib-2.0.so $(STAGING_DIR)/lib/libgobject-2.0.so $(STAGING_DIR)/lib/libgmodule-2.0.so $(STAGING_DIR)/lib/libgthread-2.0.so" \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--localstatedir=/var \
		--program-prefix="" \
		--disable-tests \
		--disable-xml-docs \
		--disable-doxygen-docs \
		--enable-asserts=yes \
	)
	touch $(DBUS_GLIB_DIR)/.configured

$(DBUS_GLIB_DIR)/$(DBUS_GLIB_BINARY): $(DBUS_GLIB_DIR)/.configured
	$(MAKE) DBUS_BUS_LIBS="$(STAGING_DIR)/lib/libexpat.so" -C $(DBUS_GLIB_DIR) all

$(STAGING_DIR)/usr/lib/libdbus-glib-1.so.2.0.0: $(DBUS_GLIB_DIR)/$(DBUS_GLIB_BINARY)
	cp -a $(DBUS_GLIB_DIR)/dbus/.libs/libdbus-glib-1.so* $(STAGING_DIR)/usr/lib
	-touch -c $(STAGING_DIR)/usr/lib/libdbus-glib-1.so.2.0.0

$(TARGET_DIR)/$(DBUS_GLIB_TARGET_BINARY): $(STAGING_DIR)/usr/lib/libdbus-glib-1.so.2.0.0
	cp -a $(DBUS_GLIB_DIR)/dbus/.libs/libdbus-glib-1.so.2* $(TARGET_DIR)/usr/lib
	cp -a $(DBUS_GLIB_DIR)/dbus/.libs/dbus-binding-tool $(TARGET_DIR)/usr/bin
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libdbus-glib-1.so.2.0.0

dbus-glib: uclibc pkgconfig dbus libglib2 $(TARGET_DIR)/$(DBUS_GLIB_TARGET_BINARY)

dbus-glib-clean:
	rm -f $(TARGET_DIR)/usr/lib/libdbus-glib-1.so.2*
	rm -f $(TARGET_DIR)/usr/bin/dbus-binding-tool
	rm -f $(STAGING_DIR)/usr/lib/libdbus-glib-1.so*
	-$(MAKE) -C $(DBUS_GLIB_DIR) clean

dbus-glib-dirclean:
	rm -rf $(DBUS_GLIB_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_DBUS_GLIB)),y)
TARGETS+=dbus-glib
endif
