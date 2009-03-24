################################################################################
#
# pixman
#
################################################################################
PIXMAN_VERSION = 0.10.0
PIXMAN_SOURCE = pixman-$(PIXMAN_VERSION).tar.gz
PIXMAN_SITE = http://cairographics.org/releases/
PIXMAN_AUTORECONF = NO
PIXMAN_INSTALL_STAGING = YES

$(eval $(call AUTOTARGETS,package,pixman))

# pixman for the host
PIXMAN_HOST_DIR:=$(BUILD_DIR)/pixman-$(PIXMAN_VERSION)-host

$(DL_DIR)/$(PIXMAN_SOURCE):
	$(call DOWNLOAD,$(PIXMAN_SITE),$(PIXMAN_SOURCE))

$(STAMP_DIR)/host_pixman_unpacked: $(DL_DIR)/$(PIXMAN_SOURCE)
	mkdir -p $(PIXMAN_HOST_DIR)
	$(INFLATE$(suffix $(PIXMAN_SOURCE))) $< | \
		$(TAR) $(TAR_STRIP_COMPONENTS)=1 -C $(PIXMAN_HOST_DIR) $(TAR_OPTIONS) -
	touch $@

$(STAMP_DIR)/host_pixman_configured: $(STAMP_DIR)/host_pixman_unpacked
	(cd $(PIXMAN_HOST_DIR); rm -rf config.cache; \
		$(HOST_CONFIGURE_OPTS) \
		CFLAGS="$(HOST_CFLAGS)" \
		LDFLAGS="$(HOST_LDFLAGS)" \
		./configure \
		--prefix="$(HOST_DIR)/usr" \
		--sysconfdir="$(HOST_DIR)/etc" \
	)
	touch $@

$(STAMP_DIR)/host_pixman_compiled: $(STAMP_DIR)/host_pixman_configured
	$(HOST_MAKE_ENV) $(MAKE) -C $(PIXMAN_HOST_DIR)
	touch $@

$(STAMP_DIR)/host_pixman_installed: $(STAMP_DIR)/host_pixman_compiled
	$(HOST_MAKE_ENV) $(MAKE) -C $(PIXMAN_HOST_DIR) install
	touch $@

host-pixman: $(STAMP_DIR)/host_pixman_installed

host-pixman-source: pixman-source

host-pixman-clean:
	rm -f $(addprefix $(STAMP_DIR)/host_pixman_,unpacked configured compiled installed)
	-$(MAKE) -C $(PIXMAN_HOST_DIR) uninstall
	-$(MAKE) -C $(PIXMAN_HOST_DIR) clean

host-pixman-dirclean:
	rm -rf $(PIXMAN_HOST_DIR)
