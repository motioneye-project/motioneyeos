#############################################################
#
# libxml2
#
#############################################################
LIBXML2_VERSION = 2.7.3
LIBXML2_SOURCE = libxml2-sources-$(LIBXML2_VERSION).tar.gz
LIBXML2_SITE = ftp://xmlsoft.org/libxml2
LIBXML2_INSTALL_STAGING = YES
LIBXML2_INSTALL_TARGET = YES

ifneq ($(BR2_LARGEFILE),y)
LIBXML2_CONF_ENV = CC="$(TARGET_CC) $(TARGET_CFLAGS) -DNO_LARGEFILE_SOURCE"
endif

LIBXML2_CONF_OPT = --with-gnu-ld --enable-shared \
		--enable-static $(DISABLE_IPV6) \
		--without-debugging --without-python \
		--without-threads 

LIBXML2_DEPENDENCIES = uclibc

$(eval $(call AUTOTARGETS,package,libxml2))

$(LIBXML2_HOOK_POST_INSTALL):
	$(SED) "s,^prefix=.*,prefix=\'$(STAGING_DIR)/usr\',g" $(STAGING_DIR)/usr/bin/xml2-config
	$(SED) "s,^exec_prefix=.*,exec_prefix=\'$(STAGING_DIR)/usr\',g" $(STAGING_DIR)/usr/bin/xml2-config
	rm -rf $(TARGET_DIR)/usr/share/aclocal \
	       $(TARGET_DIR)/usr/share/doc/libxml2-$(LIBXML2_VERSION) \
	       $(TARGET_DIR)/usr/share/gtk-doc
	touch $@

# libxml2 for the host
LIBXML2_HOST_DIR:=$(BUILD_DIR)/libxml2-$(LIBXML2_VERSION)-host
LIBXML2_HOST_BINARY:=$(HOST_DIR)/usr/bin/xmllint

$(DL_DIR)/$(LIBXML2_SOURCE):
	$(call DOWNLOAD,$(LIBXML2_SITE),$(LIBXML2_SOURCE))

$(STAMP_DIR)/host_libxml2_unpacked: $(DL_DIR)/$(LIBXML2_SOURCE)
	mkdir -p $(LIBXML2_HOST_DIR)
	$(INFLATE$(suffix $(LIBXML2_SOURCE))) $< | \
		$(TAR) $(TAR_STRIP_COMPONENTS)=1 -C $(LIBXML2_HOST_DIR) $(TAR_OPTIONS) -
	touch $@

$(STAMP_DIR)/host_libxml2_configured: $(STAMP_DIR)/host_libxml2_unpacked $(STAMP_DIR)/host_pkgconfig_installed
	(cd $(LIBXML2_HOST_DIR); rm -rf config.cache; \
		$(HOST_CONFIGURE_OPTS) \
		CFLAGS="$(HOST_CFLAGS)" \
		LDFLAGS="$(HOST_LDFLAGS)" \
		./configure \
		--prefix="$(HOST_DIR)/usr" \
		--sysconfdir="$(HOST_DIR)/etc" \
		--enable-shared --without-debugging --without-python \
		--without-threads \
	)
	touch $@

$(STAMP_DIR)/host_libxml2_compiled: $(STAMP_DIR)/host_libxml2_configured
	$(MAKE) -C $(LIBXML2_HOST_DIR)
	touch $@

$(STAMP_DIR)/host_libxml2_installed: $(STAMP_DIR)/host_libxml2_compiled
	$(HOST_MAKE_ENV) $(MAKE) -C $(LIBXML2_HOST_DIR) install
	touch $@

host-libxml2: $(STAMP_DIR)/host_libxml2_installed

host-libxml2-source: libxml2-source

host-libxml2-clean:
	rm -f $(addprefix $(STAMP_DIR)/host_libxml2_,unpacked configured compiled installed)
	-$(MAKE) -C $(LIBXML2_HOST_DIR) uninstall
	-$(MAKE) -C $(LIBXML2_HOST_DIR) clean

host-libxml2-dirclean:
	rm -rf $(LIBXML2_HOST_DIR)
