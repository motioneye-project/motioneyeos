#############################################################
#
# gob2
#
#############################################################
GOB2_VERSION = 2.0.15
GOB2_SOURCE = gob2-$(GOB2_VERSION).tar.gz
GOB2_SITE = http://ftp.5z.com/pub/gob/

GOB2_DEPENDENCIES = libglib2 flex bison host-pkgconfig

$(eval $(call AUTOTARGETS,package,gob2))

# gob2 for the host
GOB2_HOST_DIR:=$(BUILD_DIR)/gob2-$(GOB2_VERSION)-host
GOB2_HOST_BINARY:=$(HOST_DIR)/usr/bin/gob2

$(DL_DIR)/$(GOB2_SOURCE):
	$(call DOWNLOAD,$(GOB2_SITE),$(GOB2_SOURCE))

$(STAMP_DIR)/host_gob2_unpacked: $(DL_DIR)/$(GOB2_SOURCE)
	mkdir -p $(GOB2_HOST_DIR)
	$(INFLATE$(suffix $(GOB2_SOURCE))) $< | \
		$(TAR) $(TAR_STRIP_COMPONENTS)=1 -C $(GOB2_HOST_DIR) $(TAR_OPTIONS) -
	touch $@

$(STAMP_DIR)/host_gob2_configured: $(STAMP_DIR)/host_gob2_unpacked $(STAMP_DIR)/host_libglib2_installed
	(cd $(GOB2_HOST_DIR); rm -rf config.cache; \
		$(HOST_CONFIGURE_OPTS) \
		CFLAGS="$(HOST_CFLAGS)" \
		LDFLAGS="$(HOST_LDFLAGS)" \
		./configure \
		--prefix="$(HOST_DIR)/usr" \
		--sysconfdir="$(HOST_DIR)/etc" \
	)
	touch $@

$(STAMP_DIR)/host_gob2_compiled: $(STAMP_DIR)/host_gob2_configured
	$(HOST_MAKE_ENV) $(MAKE) -C $(GOB2_HOST_DIR)
	touch $@

$(STAMP_DIR)/host_gob2_installed: $(STAMP_DIR)/host_gob2_compiled
	$(HOST_MAKE_ENV) $(MAKE) -C $(GOB2_HOST_DIR) install
	touch $@

host-gob2: $(STAMP_DIR)/host_gob2_installed

host-gob2-source: gob2-source

host-gob2-clean:
	rm -f $(addprefix $(STAMP_DIR)/host_gob2_,unpacked configured compiled installed)
	-$(MAKE) -C $(GOB2_HOST_DIR) uninstall
	-$(MAKE) -C $(GOB2_HOST_DIR) clean

host-gob2-dirclean:
	rm -rf $(GOB2_HOST_DIR)
