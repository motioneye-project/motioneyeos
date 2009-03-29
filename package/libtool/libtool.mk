#############################################################
#
# libtool
#
#############################################################
LIBTOOL_VERSION = 1.5.24
LIBTOOL_SOURCE = libtool-$(LIBTOOL_VERSION).tar.gz
LIBTOOL_SITE = $(BR2_GNU_MIRROR)/libtool

ifeq ($(BR2_ENABLE_DEBUG),y) # install-exec doesn't install aclocal stuff
LIBTOOL_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install
endif

LIBTOOL_DEPENDENCIES = uclibc

$(eval $(call AUTOTARGETS,package,libtool))

# libtool for the host
LIBTOOL_HOST_DIR:=$(BUILD_DIR)/libtool-$(LIBTOOL_VERSION)-host

# variables used by other packages
LIBTOOL:=$(HOST_DIR)/usr/bin/libtool

$(DL_DIR)/$(LIBTOOL_SOURCE):
	$(call DOWNLOAD,$(LIBTOOL_SITE),$(LIBTOOL_SOURCE))

$(STAMP_DIR)/host_libtool_unpacked: $(DL_DIR)/$(LIBTOOL_SOURCE)
	mkdir -p $(LIBTOOL_HOST_DIR)
	$(INFLATE$(suffix $(LIBTOOL_SOURCE))) $< | \
		$(TAR) $(TAR_STRIP_COMPONENTS)=1 -C $(LIBTOOL_HOST_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(LIBTOOL_HOST_DIR) package/libtool/ \*.patch
	touch $@

$(STAMP_DIR)/host_libtool_configured: $(STAMP_DIR)/host_libtool_unpacked
	(cd $(LIBTOOL_HOST_DIR); rm -rf config.cache; \
		$(HOST_CONFIGURE_OPTS) \
		CFLAGS="$(HOST_CFLAGS)" \
		LDFLAGS="$(HOST_LDFLAGS)" \
		./configure \
		--prefix="$(HOST_DIR)/usr" \
		--sysconfdir="$(HOST_DIR)/etc" \
		--disable-static \
	)
	touch $@

$(STAMP_DIR)/host_libtool_compiled: $(STAMP_DIR)/host_libtool_configured
	$(MAKE) -C $(LIBTOOL_HOST_DIR)
	touch $@

$(STAMP_DIR)/host_libtool_installed: $(STAMP_DIR)/host_libtool_compiled
	$(MAKE) -C $(LIBTOOL_HOST_DIR) install
	install -D -m 0644 $(HOST_DIR)/usr/share/aclocal/libtool.m4 \
		$(STAGING_DIR)/usr/share/aclocal/libtool.m4
	install -D -m 0644 $(HOST_DIR)/usr/share/aclocal/ltdl.m4 \
		$(STAGING_DIR)/usr/share/aclocal/ltdl.m4
	touch $@

host-libtool: $(STAMP_DIR)/host_libtool_installed

host-libtool-clean:
	rm -f $(addprefix $(STAMP_DIR)/host_libtool_,unpacked configured compiled installed)
	-$(MAKE) -C $(LIBTOOL_HOST_DIR) uninstall
	-$(MAKE) -C $(LIBTOOL_HOST_DIR) clean

host-libtool-dirclean:
	rm -rf $(LIBTOOL_HOST_DIR)
