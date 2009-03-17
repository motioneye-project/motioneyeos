#############################################################
#
# expat
#
#############################################################

EXPAT_VERSION = 2.0.1
EXPAT_SOURCE = expat-$(EXPAT_VERSION).tar.gz
EXPAT_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/expat
EXPAT_LIBTOOL_PATCH = NO
EXPAT_INSTALL_STAGING = YES
EXPAT_INSTALL_TARGET = YES
# no install-strip / install-exec
EXPAT_INSTALL_STAGING_OPT = DESTDIR=$(STAGING_DIR) installlib
EXPAT_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) installlib

EXPAT_CONF_OPT = --enable-shared

EXPAT_DEPENDENCIES = uclibc pkgconfig

$(eval $(call AUTOTARGETS,package,expat))

$(EXPAT_HOOK_POST_INSTALL): $(EXPAT_TARGET_INSTALL_TARGET)
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libexpat.so.*
	touch $@

# expat for the host
EXPAT_HOST_DIR:=$(BUILD_DIR)/expat-$(EXPAT_VERSION)-host
EXPAT_HOST_BINARY:=$(HOST_DIR)/usr/lib/libexpat.a

$(EXPAT_HOST_DIR)/.unpacked: $(DL_DIR)/$(EXPAT_SOURCE)
	mkdir -p $(@D)
	$(INFLATE$(suffix $(EXPAT_SOURCE))) $< | \
		$(TAR) $(TAR_STRIP_COMPONENTS)=1 -C $(@D) $(TAR_OPTIONS) -
	touch $@

$(EXPAT_HOST_DIR)/.configured: $(EXPAT_HOST_DIR)/.unpacked
	(cd $(@D); rm -rf config.cache; \
		$(HOST_CONFIGURE_OPTS) \
		CFLAGS="$(HOST_CFLAGS)" \
		LDFLAGS="$(HOST_LDFLAGS)" \
		$(@D)/configure \
		--prefix=$(HOST_DIR)/usr \
		--sysconfdir=$(HOST_DIR)/etc \
	)
	touch $@

$(EXPAT_HOST_DIR)/.compiled: $(EXPAT_HOST_DIR)/.configured
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)
	touch $@

$(EXPAT_HOST_BINARY): $(EXPAT_HOST_DIR)/.compiled
	$(MAKE) -C $(<D) installlib

host-expat: $(EXPAT_HOST_BINARY)

host-expat-source: expat-source

host-expat-clean:
	rm -f $(addprefix $(EXPAT_HOST_DIR)/,.unpacked .configured .compiled)
	$(MAKE) -C $(EXPAT_HOST_DIR) uninstall
	$(MAKE) -C $(EXPAT_HOST_DIR) clean

host-expat-dirclean:
	rm -rf $(EXPAT_HOST_DIR)
