#############################################################
#
# dbus-glib
#
#############################################################
DBUS_GLIB_VERSION = 0.80
DBUS_GLIB_SOURCE = dbus-glib-$(DBUS_GLIB_VERSION).tar.gz
DBUS_GLIB_SITE = http://dbus.freedesktop.org/releases/dbus-glib/
DBUS_GLIB_INSTALL_STAGING = YES
DBUS_GLIB_INSTALL_TARGET = YES

DBUS_GLIB_CONF_ENV = ac_cv_have_abstract_sockets=yes \
		ac_cv_func_posix_getpwnam_r=yes \
		have_abstract_sockets=yes

DBUS_GLIB_CONF_OPT = --localstatedir=/var \
		--program-prefix="" \
		--disable-tests \
		--disable-xml-docs \
		--with-introspect-xml=$(DBUS_HOST_INTROSPECT) \
		--with-dbus-binding-tool=$(DBUS_GLIB_HOST_BINARY) \
		--disable-bash-completion \
		--disable-doxygen-docs \
		--enable-asserts=yes

DBUS_GLIB_DEPENDENCIES = uclibc host-pkgconfig dbus host-dbus host-dbus-glib libglib2 expat

$(eval $(call AUTOTARGETS,package,dbus-glib))

# dbus-glib for the host
DBUS_GLIB_HOST_DIR:=$(BUILD_DIR)/dbus-glib-$(DBUS_GLIB_VERSION)-host
DBUS_GLIB_HOST_BINARY:=$(HOST_DIR)/usr/bin/dbus-binding-tool

$(DL_DIR)/$(DBUS_GLIB_SOURCE):
	$(call DOWNLOAD,$(DBUS_GLIB_SITE),$(DBUS_GLIB_SOURCE))

$(STAMP_DIR)/host_dbusglib_unpacked: $(DL_DIR)/$(DBUS_GLIB_SOURCE)
	mkdir -p $(DBUS_GLIB_HOST_DIR)
	$(INFLATE$(suffix $(DBUS_GLIB_SOURCE))) $< | \
		$(TAR) $(TAR_STRIP_COMPONENTS)=1 -C $(DBUS_GLIB_HOST_DIR) $(TAR_OPTIONS) -
	touch $@

$(STAMP_DIR)/host_dbusglib_configured: $(STAMP_DIR)/host_dbusglib_unpacked $(STAMP_DIR)/host_dbus_installed $(STAMP_DIR)/host_expat_installed $(STAMP_DIR)/host_libglib2_installed
	(cd $(DBUS_GLIB_HOST_DIR); rm -rf config.cache; \
		$(HOST_CONFIGURE_OPTS) \
		CFLAGS="$(HOST_CFLAGS)" \
		LDFLAGS="$(HOST_LDFLAGS)" \
		./configure \
		--prefix="$(HOST_DIR)/usr" \
		--sysconfdir="$(HOST_DIR)/etc" \
		--disable-tests \
		--disable-xml-docs \
		--disable-bash-completion \
		--disable-doxygen-docs \
		--enable-asserts=yes \
	)
	touch $@

$(STAMP_DIR)/host_dbusglib_compiled: $(STAMP_DIR)/host_dbusglib_configured
	$(HOST_MAKE_ENV) $(MAKE) -C $(DBUS_GLIB_HOST_DIR)
	touch $@

$(STAMP_DIR)/host_dbusglib_installed: $(STAMP_DIR)/host_dbusglib_compiled
	$(HOST_MAKE_ENV) $(MAKE) -C $(DBUS_GLIB_HOST_DIR) install
	touch $@

host-dbus-glib: $(STAMP_DIR)/host_dbusglib_installed

host-dbus-glib-source: dbus-glib-source

host-dbus-glib-clean:
	rm -f $(addprefix $(STAMP_DIR)/host_dbusglib_,unpacked configured compiled installed)
	-$(MAKE) -C $(DBUS_GLIB_HOST_DIR) uninstall
	-$(MAKE) -C $(DBUS_GLIB_HOST_DIR) clean

host-dbus-glib-dirclean:
	rm -rf $(DBUS_GLIB_HOST_DIR)
