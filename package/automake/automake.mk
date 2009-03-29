#############################################################
#
# automake
#
#############################################################
AUTOMAKE_VERSION = 1.10
AUTOMAKE_SOURCE = automake-$(AUTOMAKE_VERSION).tar.bz2
AUTOMAKE_SITE = $(BR2_GNU_MIRROR)/automake

ifeq ($(BR2_ENABLE_DEBUG),y) # install-exec doesn't install aclocal stuff
AUTOMAKE_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install
endif

AUTOMAKE_DEPENDENCIES = uclibc autoconf microperl

$(eval $(call AUTOTARGETS,package,automake))

# automake for the host
AUTOMAKE_HOST_DIR:=$(BUILD_DIR)/automake-$(AUTOMAKE_VERSION)-host

# variables used by other packages
AUTOMAKE:=$(HOST_DIR)/usr/bin/automake
ACLOCAL_DIR = $(STAGING_DIR)/usr/share/aclocal
ACLOCAL = $(HOST_DIR)/usr/bin/aclocal -I $(ACLOCAL_DIR)

$(DL_DIR)/$(AUTOMAKE_SOURCE):
	$(call DOWNLOAD,$(AUTOMAKE_SITE),$(AUTOMAKE_SOURCE))

$(STAMP_DIR)/host_automake_unpacked: $(DL_DIR)/$(AUTOMAKE_SOURCE)
	mkdir -p $(AUTOMAKE_HOST_DIR)
	$(INFLATE$(suffix $(AUTOMAKE_SOURCE))) $< | \
		$(TAR) $(TAR_STRIP_COMPONENTS)=1 -C $(AUTOMAKE_HOST_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(AUTOMAKE_HOST_DIR) package/automake/ \*.patch
	touch $@

$(STAMP_DIR)/host_automake_configured: $(STAMP_DIR)/host_automake_unpacked $(STAMP_DIR)/host_autoconf_installed
	(cd $(AUTOMAKE_HOST_DIR); rm -rf config.cache; \
		$(HOST_CONFIGURE_OPTS) \
		CFLAGS="$(HOST_CFLAGS)" \
		LDFLAGS="$(HOST_LDFLAGS)" \
		./configure \
		--prefix="$(HOST_DIR)/usr" \
		--sysconfdir="$(HOST_DIR)/etc" \
		--disable-static \
	)
	touch $@

$(STAMP_DIR)/host_automake_compiled: $(STAMP_DIR)/host_automake_configured
	$(MAKE) -C $(AUTOMAKE_HOST_DIR)
	touch $@

$(STAMP_DIR)/host_automake_installed: $(STAMP_DIR)/host_automake_compiled
	$(MAKE) -C $(AUTOMAKE_HOST_DIR) install
	mkdir -p $(STAGING_DIR)/usr/share/aclocal
	touch $@

host-automake: $(STAMP_DIR)/host_automake_installed

host-automake-clean:
	rm -f $(addprefix $(STAMP_DIR)/host_automake_,unpacked configured compiled installed)
	-$(MAKE) -C $(AUTOMAKE_HOST_DIR) uninstall
	-$(MAKE) -C $(AUTOMAKE_HOST_DIR) clean

host-automake-dirclean:
	rm -rf $(AUTOMAKE_HOST_DIR)
