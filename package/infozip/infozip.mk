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

# Disable the support of 16-bit UIDs/GIDs, the test in unix/configure was
# removed since it can't work for cross-compilation.
INFOZIP_CFLAGS += -DUIDGID_NOT_16BIT

# infozip already defines _LARGEFILE_SOURCE and _LARGEFILE64_SOURCE when
# necessary, redefining it on the command line causes some warnings.
INFOZIP_TARGET_CFLAGS = \
	$(filter-out -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE,$(TARGET_CFLAGS))

define INFOZIP_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) \
		CFLAGS="$(INFOZIP_TARGET_CFLAGS) $(INFOZIP_CFLAGS)" \
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
