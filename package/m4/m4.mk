#############################################################
#
# m4
#
#############################################################
M4_VERSION = 1.4.9
M4_SOURCE = m4-$(M4_VERSION).tar.bz2
M4_SITE = $(BR2_GNU_MIRROR)/m4

ifeq ($(BR2_ENABLE_DEBUG),y) # no install-exec
M4_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install
endif

M4_CONF_ENV = gl_cv_func_gettimeofday_clobber=no

ifneq ($(BR2_USE_WCHAR),y)
M4_CONF_ENV += gt_cv_c_wchar_t=no gl_cv_absolute_wchar_h=__fpending.h
endif

M4_DEPENDENCIES = uclibc

$(eval $(call AUTOTARGETS,package,m4))

# m4 for the host
M4_HOST_DIR:=$(BUILD_DIR)/m4-$(M4_VERSION)-host

$(DL_DIR)/$(M4_SOURCE):
	$(call DOWNLOAD,$(M4_SITE),$(M4_SOURCE))

$(STAMP_DIR)/host_m4_unpacked: $(DL_DIR)/$(M4_SOURCE)
	mkdir -p $(M4_HOST_DIR)
	$(INFLATE$(suffix $(M4_SOURCE))) $< | \
		$(TAR) $(TAR_STRIP_COMPONENTS)=1 -C $(M4_HOST_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(M4_HOST_DIR) package/m4/ \*.patch
	touch $@

$(STAMP_DIR)/host_m4_configured: $(STAMP_DIR)/host_m4_unpacked
	(cd $(M4_HOST_DIR); rm -rf config.cache; \
		$(HOST_CONFIGURE_OPTS) \
		CFLAGS="$(HOST_CFLAGS)" \
		LDFLAGS="$(HOST_LDFLAGS)" \
		./configure \
		--prefix="$(HOST_DIR)/usr" \
		--sysconfdir="$(HOST_DIR)/etc" \
		--disable-static \
	)
	touch $@

$(STAMP_DIR)/host_m4_compiled: $(STAMP_DIR)/host_m4_configured
	$(MAKE) -C $(M4_HOST_DIR)
	touch $@

$(STAMP_DIR)/host_m4_installed: $(STAMP_DIR)/host_m4_compiled
	$(MAKE) -C $(M4_HOST_DIR) install
	touch $@

host-m4: $(STAMP_DIR)/host_m4_installed

host-m4-clean:
	rm -f $(addprefix $(STAMP_DIR)/host_m4_,unpacked configured compiled installed)
	-$(MAKE) -C $(M4_HOST_DIR) uninstall
	-$(MAKE) -C $(M4_HOST_DIR) clean

host-m4-dirclean:
	rm -rf $(M4_HOST_DIR)
