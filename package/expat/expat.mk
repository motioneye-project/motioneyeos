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

EXPAT_DEPENDENCIES = uclibc host-pkgconfig

$(eval $(call AUTOTARGETS,package,expat))

$(EXPAT_HOOK_POST_INSTALL): $(EXPAT_TARGET_INSTALL_TARGET)
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libexpat.so.*
	touch $@

# expat for the host
EXPAT_HOST_DIR:=$(BUILD_DIR)/expat-$(EXPAT_VERSION)-host

$(DL_DIR)/$(EXPAT_SOURCE):
	$(call DOWNLOAD,$(EXPAT_SITE),$(EXPAT_SOURCE))

$(STAMP_DIR)/host_expat_unpacked: $(DL_DIR)/$(EXPAT_SOURCE)
	mkdir -p $(EXPAT_HOST_DIR)
	$(INFLATE$(suffix $(EXPAT_SOURCE))) $< | \
		$(TAR) $(TAR_STRIP_COMPONENTS)=1 -C $(EXPAT_HOST_DIR) $(TAR_OPTIONS) -
	touch $@

$(STAMP_DIR)/host_expat_configured: $(STAMP_DIR)/host_expat_unpacked
	(cd $(EXPAT_HOST_DIR); rm -rf config.cache; \
		$(HOST_CONFIGURE_OPTS) \
		CFLAGS="$(HOST_CFLAGS)" \
		LDFLAGS="$(HOST_LDFLAGS)" \
		./configure \
		--prefix="$(HOST_DIR)/usr" \
		--sysconfdir="$(HOST_DIR)/etc" \
	)
	touch $@

$(STAMP_DIR)/host_expat_compiled: $(STAMP_DIR)/host_expat_configured
	$(HOST_MAKE_ENV) $(MAKE) -C $(EXPAT_HOST_DIR)
	touch $@

$(STAMP_DIR)/host_expat_installed: $(STAMP_DIR)/host_expat_compiled
	$(MAKE) -C $(EXPAT_HOST_DIR) installlib
	touch $@

host-expat: $(STAMP_DIR)/host_expat_installed

host-expat-source: expat-source

host-expat-clean:
	rm -f $(addprefix $(STAMP_DIR)/host_expat_,unpacked configured compiled installed)
	-$(MAKE) -C $(EXPAT_HOST_DIR) uninstall
	-$(MAKE) -C $(EXPAT_HOST_DIR) clean

host-expat-dirclean:
	rm -rf $(EXPAT_HOST_DIR)
