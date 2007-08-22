#############################################################
#
# hal
#
#############################################################
HAL_VERSION:=0.5.8
HAL_SOURCE:=hal-$(HAL_VERSION).tar.gz
HAL_SITE:=http://people.freedesktop.org/~david/dist/
HAL_DIR:=$(BUILD_DIR)/hal-$(HAL_VERSION)
HAL_CAT:=$(ZCAT)
HAL_BINARY:=hald/hald
HAL_TARGET_BINARY:=usr/sbin/hald

GLIB_CFLAGS:=-I$(STAGING_DIR)/usr/include/glib-2.0 \
	     -I$(STAGING_DIR)/lib/glib/include
GLIB_LIBS:=$(STAGING_DIR)/lib/libglib-2.0.so \
	   $(STAGING_DIR)/lib/libgmodule-2.0.so \
	   $(STAGING_DIR)/lib/libgobject-2.0.so \
	   $(STAGING_DIR)/lib/libgthread-2.0.so
DBUS_GLIB_LIBS:=$(STAGING_DIR)/usr/lib/libdbus-glib-1.so

$(DL_DIR)/$(HAL_SOURCE):
	$(WGET) -P $(DL_DIR) $(HAL_SITE)/$(HAL_SOURCE)

hal-source: $(DL_DIR)/$(HAL_SOURCE)

$(HAL_DIR)/.unpacked: $(DL_DIR)/$(HAL_SOURCE)
	$(HAL_CAT) $(DL_DIR)/$(HAL_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(HAL_DIR) package/hal/ \*.patch
	touch $(HAL_DIR)/.unpacked

$(HAL_DIR)/.configured: $(HAL_DIR)/.unpacked /usr/bin/pkg-config
	(cd $(HAL_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		CFLAGS="$(TARGET_CFLAGS) -I$(STAGING_DIR)/lib/glib-2.0/include" \
		GLIB_CFLAGS="$(GLIB_CFLAGS)" \
		GLIB_LIBS="$(GLIB_LIBS)" \
		DBUS_CFLAGS="-I$(STAGING_DIR)/usr/include/dbus-1.0 -I$(STAGING_DIR)/usr/lib/dbus-1.0/include" \
		DBUS_LIBS="$(STAGING_DIR)/usr/lib/libdbus-1.so" \
		VOLUME_ID_CFLAGS="$(TARGET_CFLAGS)" \
		VOLUME_ID_LIBS="$(STAGING_DIR)/usr/lib/libvolume_id.so" \
		PKG_CONFIG=/usr/bin/pkg-config \
		ac_cv_path_LIBUSB_CONFIG= \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--datadir=/usr/share \
		--sysconfdir=/etc \
		--localstatedir=/var \
		--with-hwdata=$(TARGET_DIR)/usr/share/hwdata \
		--disable-policy-kit \
		--disable-gtk-doc \
		--disable-static \
		--disable-acpi-acpid \
		--disable-acpi-proc \
	)
	touch $(HAL_DIR)/.configured

$(HAL_DIR)/hald/hald: $(HAL_DIR)/.configured
	$(MAKE) STAGING_DIR="$(STAGING_DIR)" DESTDIR="$(TARGET_DIR)" DBUS_GLIB_LIBS="$(DBUS_GLIB_LIBS)" -C $(HAL_DIR)

$(TARGET_DIR)/$(HAL_TARGET_BINARY): $(HAL_DIR)/hald/hald
	$(MAKE) STAGING_DIR="$(STAGING_DIR)" DESTDIR="$(TARGET_DIR)" -C $(HAL_DIR) install
	rm -rf $(TARGET_DIR)/usr/share/locale
	rm -rf $(TARGET_DIR)/usr/share/doc
	rm -rf $(TARGET_DIR)/usr/share/gtk-doc
	rm -rf $(TARGET_DIR)/usr/share/hal/device-manager
	rm -rf $(TARGET_DIR)/usr/lib/pkgconfig
	# remove _everything_ in $(TARGET_DIR)/usr/include?
	# rm -rf $(TARGET_DIR)/usr/include
	rm -rf $(TARGET_DIR)/usr/lib/libhal*.so
	rm -rf $(TARGET_DIR)/usr/lib/libhal*.la
	rm -rf $(TARGET_DIR)/usr/lib/hal
	rm -rf $(TARGET_DIR)/etc/PolicyKit
	$(INSTALL) -m 0755 -D package/hal/S98haldaemon $(TARGET_DIR)/etc/init.d
	rm -rf $(TARGET_DIR)/etc/rc.d
	for file in hald-addon-acpi* hald-addon-cpufreq \
		hald-addon-keyboard hald-addon-pmu \
		hald-probe-pc-floppy hald-probe-printer \
		hald-probe-serial hald-probe-smbios \
		hal-storage-eject hal-storage-closetray \
		hal-system-power-pmu hald-probe-input \
		hald-probe-hiddev hald-addon-hid-ups; \
	do \
		rm -f $(TARGET_DIR)/usr/libexec/$$file; \
	done
	-$(STRIP) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libhal*

hal: uclibc dbus-glib hwdata udev-volume_id $(TARGET_DIR)/$(HAL_TARGET_BINARY)

hal-clean:
	rm -f $(TARGET_DIR)/etc/dbus-1/system.d/hal.conf
	rm -rf $(TARGET_DIR)/etc/hal $(TARGET_DIR)/usr/share/hal
	rm -f $(TARGET_DIR)/etc/init.d/S98haldaemon
	rm -f $(TARGET_DIR)/etc/udev/rules.d/90-hal.rules
	rm -f $(TARGET_DIR)/usr/bin/hal-* $(TARGET_DIR)/usr/bin/lshal
	rm -f $(TARGET_DIR)/usr/sbin/hald
	rm -f $(TARGET_DIR)/usr/libexec/hald-* $(TARGET_DIR)/usr/libexec/hal-*
	rmdir -p --ignore-fail-on-non-empty $(TARGET_DIR)/usr/libexec
	rm -f $(TARGET_DIR)/usr/lib/libhal.so.1*
	rm -f $(TARGET_DIR)/usr/lib/libhal-storage.so.1*
	-$(MAKE) -C $(HAL_DIR) clean

hal-dirclean:
	rm -rf $(HAL_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_HAL)),y)
TARGETS+=hal
endif
