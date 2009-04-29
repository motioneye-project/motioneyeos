#############################################################
#
# shared-mime-info
#
#############################################################
SHARED_MIME_INFO_VERSION = 0.60
SHARED_MIME_INFO_SOURCE = shared-mime-info-$(SHARED_MIME_INFO_VERSION).tar.bz2
SHARED_MIME_INFO_SITE = http://freedesktop.org/~hadess

SHARED_MIME_INFO_INSTALL_STAGING = YES
SHARED_MIME_INFO_INSTALL_TARGET = NO

SHARED_MIME_INFO_AUTORECONF = NO
SHARED_MIME_INFO_CONF_ENV = XMLLINT=$(HOST_DIR)/usr/bin/xmllint
SHARED_MIME_INFO_DEPENDENCIES = uclibc host-pkgconfig host-libglib2 host-libxml2

SHARED_MIME_INFO_CONF_OPT = --disable-update-mimedb

$(eval $(call AUTOTARGETS,package,shared-mime-info))


# shared-mime-info for the host
SHARED_MIME_INFO_HOST_DIR:=$(BUILD_DIR)/shared-mime-info-$(SHARED_MIME_INFO_VERSION)-host
SHARED_MIME_INFO_HOST_BINARY:=$(HOST_DIR)/usr/bin/update-mime-database

$(DL_DIR)/$(SHARED_MIME_INFO_SOURCE):
	$(call DOWNLOAD,$(SHARED_MIME_INFO_SITE),$(SHARED_MIME_INFO_SOURCE))

$(STAMP_DIR)/host_shared-mime-info_unpacked: $(DL_DIR)/$(SHARED_MIME_INFO_SOURCE)
	mkdir -p $(SHARED_MIME_INFO_HOST_DIR)
	$(INFLATE$(suffix $(SHARED_MIME_INFO_SOURCE))) $< | \
		$(TAR) $(TAR_STRIP_COMPONENTS)=1 -C $(SHARED_MIME_INFO_HOST_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(SHARED_MIME_INFO_HOST_DIR) package/shared-mime-info/ \*.patch
	touch $@

$(STAMP_DIR)/host_shared-mime-info_configured: $(STAMP_DIR)/host_shared-mime-info_unpacked $(STAMP_DIR)/host_pkgconfig_installed
	(cd $(SHARED_MIME_INFO_HOST_DIR); rm -rf config.cache; \
		$(HOST_CONFIGURE_OPTS) \
		CFLAGS="$(HOST_CFLAGS)" \
		LDFLAGS="$(HOST_LDFLAGS)" \
		./configure \
		--prefix="$(HOST_DIR)/usr" \
		--sysconfdir="$(HOST_DIR)/etc" \
		--disable-update-mimedb \
	)
	touch $@

$(STAMP_DIR)/host_shared-mime-info_compiled: $(STAMP_DIR)/host_shared-mime-info_configured
	$(MAKE) -C $(SHARED_MIME_INFO_HOST_DIR)
	touch $@

$(STAMP_DIR)/host_shared-mime-info_installed: $(STAMP_DIR)/host_shared-mime-info_compiled
	$(HOST_MAKE_ENV) $(MAKE) -C $(SHARED_MIME_INFO_HOST_DIR) install
	touch $@

host-shared-mime-info: $(STAMP_DIR)/host_shared-mime-info_installed

host-shared-mime-info-source: shared-mime-info-source

host-shared-mime-info-clean:
	rm -f $(addprefix $(STAMP_DIR)/host_shared-mime-info_,unpacked configured compiled installed)
	-$(MAKE) -C $(SHARED_MIME_INFO_HOST_DIR) uninstall
	-$(MAKE) -C $(SHARED_MIME_INFO_HOST_DIR) clean

host-shared-mime-info-dirclean:
	rm -rf $(SHARED_MIME_INFO_HOST_DIR)

# update the shared-mime-info database in the target
$(SHARED_MIME_INFO_HOOK_POST_INSTALL): host-shared-mime-info
	$(SHARED_MIME_INFO_HOST_BINARY) $(STAGING_DIR)/usr/share/mime
	$(INSTALL) -D $(STAGING_DIR)/usr/share/mime/mime.cache $(TARGET_DIR)/usr/share/mime/mime.cache
