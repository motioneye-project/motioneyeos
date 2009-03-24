#############################################################
#
# autoconf
#
#############################################################
AUTOCONF_VERSION = 2.63
AUTOCONF_SOURCE = autoconf-$(AUTOCONF_VERSION).tar.bz2
AUTOCONF_SITE = $(BR2_GNU_MIRROR)/autoconf

ifeq ($(BR2_ENABLE_DEBUG),y) # install-exec doesn't install aclocal stuff
AUTOCONF_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install
endif

AUTOCONF_CONF_ENV = EMACS="no"

AUTOCONF_DEPENDENCIES = uclibc microperl

$(eval $(call AUTOTARGETS,package,autoconf))

# autoconf for the host
AUTOCONF_HOST_DIR:=$(BUILD_DIR)/autoconf-$(AUTOCONF_VERSION)-host

# variables used by other packages
AUTOCONF:=$(HOST_DIR)/usr/bin/autoconf
AUTORECONF=$(HOST_CONFIGURE_OPTS) ACLOCAL="$(ACLOCAL)" $(HOST_DIR)/usr/bin/autoreconf -v -f -i -I "$(ACLOCAL_DIR)"

$(DL_DIR)/$(AUTOCONF_SOURCE):
	$(call DOWNLOAD,$(AUTOCONF_SITE),$(AUTOCONF_SOURCE))

$(STAMP_DIR)/host_autoconf_unpacked: $(DL_DIR)/$(AUTOCONF_SOURCE)
	mkdir -p $(AUTOCONF_HOST_DIR)
	$(INFLATE$(suffix $(AUTOCONF_SOURCE))) $< | \
		$(TAR) $(TAR_STRIP_COMPONENTS)=1 -C $(AUTOCONF_HOST_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(AUTOCONF_HOST_DIR) package/autoconf/ \*.patch
	touch $@

$(STAMP_DIR)/host_autoconf_configured: $(STAMP_DIR)/host_autoconf_unpacked $(STAMP_DIR)/host_m4_installed  $(STAMP_DIR)/host_libtool_installed
	(cd $(AUTOCONF_HOST_DIR); rm -rf config.cache; \
		$(HOST_CONFIGURE_OPTS) \
		CFLAGS="$(HOST_CFLAGS)" \
		LDFLAGS="$(HOST_LDFLAGS)" \
		./configure \
		--prefix="$(HOST_DIR)/usr" \
		--sysconfdir="$(HOST_DIR)/etc" \
		--disable-static \
	)
	touch $@

$(STAMP_DIR)/host_autoconf_compiled: $(STAMP_DIR)/host_autoconf_configured
	$(MAKE) -C $(AUTOCONF_HOST_DIR)
	touch $@

$(STAMP_DIR)/host_autoconf_installed: $(STAMP_DIR)/host_autoconf_compiled
	$(MAKE) -C $(AUTOCONF_HOST_DIR) install
	touch $@

host-autoconf: $(STAMP_DIR)/host_autoconf_installed

host-autoconf-clean:
	rm -f $(addprefix $(STAMP_DIR)/host_autoconf_,unpacked configured compiled installed)
	-$(MAKE) -C $(AUTOCONF_HOST_DIR) uninstall
	-$(MAKE) -C $(AUTOCONF_HOST_DIR) clean

host-autoconf-dirclean:
	rm -rf $(AUTOCONF_HOST_DIR)
