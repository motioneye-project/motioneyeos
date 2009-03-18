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
PIXMAN_HOST_BINARY:=$(HOST_DIR)/usr/lib/libpixman-1.0.a

$(PIXMAN_HOST_DIR)/.unpacked: $(DL_DIR)/$(PIXMAN_SOURCE)
	mkdir -p $(@D)
	$(INFLATE$(suffix $(PIXMAN_SOURCE))) $< | \
		$(TAR) $(TAR_STRIP_COMPONENTS)=1 -C $(@D) $(TAR_OPTIONS) -
	touch $@

$(PIXMAN_HOST_DIR)/.configured: $(PIXMAN_HOST_DIR)/.unpacked
	(cd $(@D); rm -rf config.cache; \
		$(HOST_CONFIGURE_OPTS) \
		CFLAGS="$(HOST_CFLAGS)" \
		LDFLAGS="$(HOST_LDFLAGS)" \
		$(@D)/configure \
		--prefix=$(HOST_DIR)/usr \
		--sysconfdir=$(HOST_DIR)/etc \
	)
	touch $@

$(PIXMAN_HOST_DIR)/.compiled: $(PIXMAN_HOST_DIR)/.configured
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)
	touch $@

$(PIXMAN_HOST_BINARY): $(PIXMAN_HOST_DIR)/.compiled
	$(HOST_MAKE_ENV) $(MAKE) -C $(<D) install

host-pixman: $(PIXMAN_HOST_BINARY)

host-pixman-source: pixman-source

host-pixman-clean:
	rm -f $(addprefix $(PIXMAN_HOST_DIR)/,.unpacked .configured .compiled)
	-$(MAKE) -C $(PIXMAN_HOST_DIR) uninstall
	-$(MAKE) -C $(PIXMAN_HOST_DIR) clean

host-pixman-dirclean:
	rm -rf $(PIXMAN_HOST_DIR)
