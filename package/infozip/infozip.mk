################################################################################
#
# infozip
#
################################################################################

INFOZIP_VERSION = 30
INFOZIP_SOURCE = zip$(INFOZIP_VERSION).tgz
INFOZIP_SITE = ftp://ftp.info-zip.org/pub/infozip/src
INFOZIP_LICENSE = Info-ZIP
INFOZIP_LICENSE_FILES = LICENSE

ifeq ($(BR2_PACKAGE_BZIP2),y)
INFOZIP_DEPENDENCIES += bzip2
endif

# Infozip's default CFLAGS.
INFOZIP_CFLAGS = -I. -DUNIX

define INFOZIP_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) \
		CFLAGS="$(TARGET_CFLAGS) $(INFOZIP_CFLAGS)" \
		AS="$(TARGET_CC) -c" \
		-f unix/Makefile generic
endef

define INFOZIP_INSTALL_TARGET_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) -f unix/Makefile install \
		prefix=$(TARGET_DIR)/usr
endef

define HOST_INFOZIP_BUILD_CMDS
	$(MAKE) $(HOST_CONFIGURE_OPTS) -C $(@D) \
		CFLAGS="$(HOST_CFLAGS) $(INFOZIP_CFLAGS)" \
		AS="$(HOSTCC) -c" \
		-f unix/Makefile generic
endef

define HOST_INFOZIP_INSTALL_CMDS
	$(MAKE) $(HOST_CONFIGURE_OPTS) -C $(@D) -f unix/Makefile install \
		prefix=$(HOST_DIR)/usr
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
