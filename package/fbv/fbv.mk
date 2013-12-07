################################################################################
#
# fbv
#
################################################################################

FBV_VERSION = 1.0b
FBV_SITE = http://s-tech.elsat.net.pl/fbv

FBV_LICENSE = GPLv2
FBV_LICENSE_FILES = COPYING

### image format dependencies and configure options
FBV_DEPENDENCIES = # empty
FBV_CONFIGURE_OPTS = # empty
ifeq ($(BR2_PACKAGE_FBV_PNG),y)
FBV_DEPENDENCIES += libpng
else
FBV_CONFIGURE_OPTS += --without-libpng
endif
ifeq ($(BR2_PACKAGE_FBV_JPEG),y)
FBV_DEPENDENCIES += jpeg
else
FBV_CONFIGURE_OPTS += --without-libjpeg
endif
ifeq ($(BR2_PACKAGE_FBV_GIF),y)
FBV_DEPENDENCIES += libungif
else
FBV_CONFIGURE_OPTS += --without-libungif
endif

#fbv donesn't support cross-compilation
define FBV_CONFIGURE_CMDS
	(cd $(FBV_DIR); rm -f config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--prefix=/usr \
		$(FBV_CONFIGURE_OPTS) \
	)
endef

define FBV_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define FBV_INSTALL_TARGET_CMDS
	install -D $(@D)/fbv $(TARGET_DIR)/usr/bin/fbv
endef

$(eval $(autotools-package))
