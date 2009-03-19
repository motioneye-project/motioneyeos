#############################################################
#
# pkgconfig
#
#############################################################
PKG_CONFIG_VERSION = 0.23
PKG_CONFIG_SOURCE = pkg-config-$(PKG_CONFIG_VERSION).tar.gz
PKG_CONFIG_SITE = http://pkgconfig.freedesktop.org/releases/

ifeq ($(BR2_ENABLE_DEBUG),y) # install-exec doesn't install aclocal stuff
PKG_CONFIG_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install-exec
endif

PKG_CONFIG_DEPENDENCIES = uclibc libglib2

PKG_CONFIG_CONF_OPT = --with-installed-glib

$(eval $(call AUTOTARGETS,package,pkgconfig))

# pkg-config for the host
PKG_CONFIG_HOST_DIR:=$(BUILD_DIR)/pkg-config-$(PKG_CONFIG_VERSION)-host
PKG_CONFIG_HOST_BINARY:=$(HOST_DIR)/usr/bin/pkg-config

$(PKG_CONFIG_HOST_DIR)/.unpacked: $(DL_DIR)/$(PKG_CONFIG_SOURCE)
	mkdir -p $(@D)
	$(INFLATE$(suffix $(PKG_CONFIG_SOURCE))) $< | \
		$(TAR) $(TAR_STRIP_COMPONENTS)=1 -C $(@D) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(@D) package/pkgconfig/ \*.patch
	touch $@

$(PKG_CONFIG_HOST_DIR)/.configured: $(PKG_CONFIG_HOST_DIR)/.unpacked
	(cd $(@D); rm -rf config.cache; \
		./configure \
		--prefix=$(HOST_DIR)/usr \
		--sysconfdir=$(HOST_DIR)/etc \
		--with-pc-path="$(STAGING_DIR)/usr/lib/pkgconfig" \
		--disable-static \
	)
	touch $@

$(PKG_CONFIG_HOST_DIR)/.compiled: $(PKG_CONFIG_HOST_DIR)/.configured
	$(MAKE) -C $(@D)
	touch $@

$(PKG_CONFIG_HOST_BINARY): $(PKG_CONFIG_HOST_DIR)/.compiled
	$(MAKE) -C $(<D) install

host-pkgconfig: $(PKG_CONFIG_HOST_BINARY)

host-pkgconfig-clean:
	rm -f $(addprefix $(PKG_CONFIG_HOST_DIR)/,.unpacked .configured .compiled)
	-$(MAKE) -C $(PKG_CONFIG_HOST_DIR) uninstall
	-$(MAKE) -C $(PKG_CONFIG_HOST_DIR) clean

host-pkgconfig-dirclean:
	rm -rf $(PKG_CONFIG_HOST_DIR)
