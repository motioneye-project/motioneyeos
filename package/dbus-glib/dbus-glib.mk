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

DBUS_GLIB_DEPENDENCIES = uclibc pkgconfig dbus host-dbus host-dbus-glib libglib2

$(eval $(call AUTOTARGETS,package,dbus-glib))

# dbus-glib for the host
DBUS_GLIB_HOST_DIR:=$(BUILD_DIR)/dbus-glib-$(DBUS_GLIB_VERSION)-host
DBUS_GLIB_HOST_BINARY:=$(HOST_DIR)/usr/bin/dbus-binding-tool

$(DBUS_GLIB_HOST_DIR)/.unpacked: $(DL_DIR)/$(DBUS_GLIB_SOURCE)
	mkdir -p $(@D)
	$(INFLATE$(suffix $(DBUS_GLIB_SOURCE))) $< | \
		$(TAR) $(TAR_STRIP_COMPONENTS)=1 -C $(@D) $(TAR_OPTIONS) -
	touch $@

$(DBUS_GLIB_HOST_DIR)/.configured: $(DBUS_GLIB_HOST_DIR)/.unpacked $(EXPAT_HOST_BINARY)
	(cd $(@D); rm -rf config.cache; \
		$(HOST_CONFIGURE_OPTS) \
		CFLAGS="$(HOST_CFLAGS)" \
		LDFLAGS="$(HOST_LDFLAGS)" \
		$(@D)/configure \
		--prefix=$(HOST_DIR)/usr \
		--sysconfdir=$(HOST_DIR)/etc \
		--disable-tests \
		--disable-xml-docs \
		--disable-bash-completion \
		--disable-doxygen-docs \
		--enable-asserts=yes \
	)
	touch $@

$(DBUS_GLIB_HOST_DIR)/.compiled: $(DBUS_GLIB_HOST_DIR)/.configured
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)
	touch $@

$(DBUS_GLIB_HOST_BINARY): $(DBUS_GLIB_HOST_DIR)/.compiled
	$(MAKE) -C $(<D) install

host-dbus-glib: $(DBUS_GLIB_HOST_BINARY)

host-dbus-glib-source: dbus-glib-source

host-dbus-glib-clean:
	rm -f $(addprefix $(DBUS_GLIB_HOST_DIR)/,.unpacked .configured .compiled)
	$(MAKE) -C $(DBUS_GLIB_HOST_DIR) uninstall
	$(MAKE) -C $(DBUS_GLIB_HOST_DIR) clean

host-dbus-glib-dirclean:
	rm -rf $(DBUS_GLIB_HOST_DIR)
