################################################################################
#
# xproto_xproto -- X.Org xproto protocol headers
#
################################################################################

XPROTO_XPROTO_VERSION = 7.0.13
XPROTO_XPROTO_SOURCE = xproto-$(XPROTO_XPROTO_VERSION).tar.bz2
XPROTO_XPROTO_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_XPROTO_AUTORECONF = NO
XPROTO_XPROTO_INSTALL_STAGING = YES
XPROTO_XPROTO_INSTALL_TARGET = NO

$(eval $(call AUTOTARGETS,package/x11r7,xproto_xproto))

# xproto_xproto for the host
XPROTO_XPROTO_HOST_DIR:=$(BUILD_DIR)/xproto_xproto-$(XPROTO_XPROTO_VERSION)-host

$(DL_DIR)/$(XPROTO_XPROTO_SOURCE):
	$(call DOWNLOAD,$(XPROTO_XPROTO_SITE),$(XPROTO_XPROTO_SOURCE))

$(STAMP_DIR)/host_xproto_xproto_unpacked: $(DL_DIR)/$(XPROTO_XPROTO_SOURCE)
	mkdir -p $(XPROTO_XPROTO_HOST_DIR)
	$(INFLATE$(suffix $(XPROTO_XPROTO_SOURCE))) $< | \
		$(TAR) $(TAR_STRIP_COMPONENTS)=1 -C $(XPROTO_XPROTO_HOST_DIR) $(TAR_OPTIONS) -
	touch $@

$(STAMP_DIR)/host_xproto_xproto_configured: $(STAMP_DIR)/host_xproto_xproto_unpacked
	(cd $(XPROTO_XPROTO_HOST_DIR); rm -rf config.cache; \
		$(HOST_CONFIGURE_OPTS) \
		CFLAGS="$(HOST_CFLAGS)" \
		LDFLAGS="$(HOST_LDFLAGS)" \
		./configure \
		--prefix="$(HOST_DIR)/usr" \
		--sysconfdir="$(HOST_DIR)/etc" \
	)
	touch $@

$(STAMP_DIR)/host_xproto_xproto_compiled: $(STAMP_DIR)/host_xproto_xproto_configured
	$(HOST_MAKE_ENV) $(MAKE) -C $(XPROTO_XPROTO_HOST_DIR)
	touch $@

$(STAMP_DIR)/host_xproto_xproto_installed: $(STAMP_DIR)/host_xproto_xproto_compiled
	$(MAKE) -C $(XPROTO_XPROTO_HOST_DIR) install
	touch $@

host-xproto_xproto: $(STAMP_DIR)/host_xproto_xproto_installed

host-xproto_xproto-source: xproto_xproto-source

host-xproto_xproto-clean:
	rm -f $(addprefix $(STAMP_DIR)/host_xproto_xproto_,unpacked configured compiled installed)
	-$(MAKE) -C $(XPROTO_XPROTO_HOST_DIR) uninstall
	-$(MAKE) -C $(XPROTO_XPROTO_HOST_DIR) clean

host-xproto_xproto-dirclean:
	rm -rf $(XPROTO_XPROTO_HOST_DIR)
