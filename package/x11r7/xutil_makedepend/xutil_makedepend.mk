################################################################################
#
# xutil_makedepend -- No description available
#
################################################################################

XUTIL_MAKEDEPEND_VERSION = 1.0.1
XUTIL_MAKEDEPEND_SOURCE = makedepend-$(XUTIL_MAKEDEPEND_VERSION).tar.bz2
XUTIL_MAKEDEPEND_SITE = http://xorg.freedesktop.org/releases/individual/util
XUTIL_MAKEDEPEND_AUTORECONF = NO
XUTIL_MAKEDEPEND_INSTALL_STAGING = NO
XUTIL_MAKEDEPEND_INSTALL_TARGET = YES

$(eval $(call AUTOTARGETS,package/x11r7,xutil_makedepend))

# makedepend for the host
MAKEDEPEND_HOST_DIR:=$(BUILD_DIR)/makedepend-$(XUTIL_MAKEDEPEND_VERSION)-host

$(DL_DIR)/$(XUTIL_MAKEDEPEND_SOURCE):
	$(call DOWNLOAD,$(XUTIL_MAKEDEPEND_SITE),$(XUTIL_MAKEDEPEND_SOURCE))

$(STAMP_DIR)/host_makedepend_unpacked: $(DL_DIR)/$(XUTIL_MAKEDEPEND_SOURCE)
	mkdir -p $(MAKEDEPEND_HOST_DIR)
	$(INFLATE$(suffix $(XUTIL_MAKEDEPEND_SOURCE))) $< | \
		$(TAR) $(TAR_STRIP_COMPONENTS)=1 -C $(MAKEDEPEND_HOST_DIR) $(TAR_OPTIONS) -
	touch $@

$(STAMP_DIR)/host_makedepend_configured: $(STAMP_DIR)/host_makedepend_unpacked $(STAMP_DIR)/host_xproto_xproto_installed
	(cd $(MAKEDEPEND_HOST_DIR); rm -rf config.cache; \
		$(HOST_CONFIGURE_OPTS) \
		CFLAGS="$(HOST_CFLAGS)" \
		LDFLAGS="$(HOST_LDFLAGS)" \
		./configure \
		--prefix="$(HOST_DIR)/usr" \
		--sysconfdir="$(HOST_DIR)/etc" \
	)
	touch $@

$(STAMP_DIR)/host_makedepend_compiled: $(STAMP_DIR)/host_makedepend_configured
	$(HOST_MAKE_ENV) $(MAKE) -C $(MAKEDEPEND_HOST_DIR)
	touch $@

$(STAMP_DIR)/host_makedepend_installed: $(STAMP_DIR)/host_makedepend_compiled
	$(MAKE) -C $(MAKEDEPEND_HOST_DIR) install
	touch $@

host-makedepend: $(STAMP_DIR)/host_makedepend_installed

host-makedepend-source: makedepend-source

host-makedepend-clean:
	rm -f $(addprefix $(STAMP_DIR)/host_makedepend_,unpacked configured compiled installed)
	-$(MAKE) -C $(MAKEDEPEND_HOST_DIR) uninstall
	-$(MAKE) -C $(MAKEDEPEND_HOST_DIR) clean

host-makedepend-dirclean:
	rm -rf $(MAKEDEPEND_HOST_DIR)
