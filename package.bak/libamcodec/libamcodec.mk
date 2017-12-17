################################################################################
#
# libamcodec
#
################################################################################

LIBAMCODEC_VERSION = 296f39bc6fc47ddf5d88b9fd3cfb82a5b39048ca
LIBAMCODEC_SITE = $(call github,mdrjr,c2_aml_libs,$(LIBAMCODEC_VERSION))
LIBAMCODEC_DEPENDENCIES = alsa-lib
LIBAMCODEC_LICENSE = Unclear
LIBAMCODEC_INSTALL_STAGING = YES

# This package uses the AML_LIBS_STAGING_DIR variable to construct the
# header and library paths used when compiling
define LIBAMCODEC_BUILD_CMDS
	$(foreach d,amavutils amadec amcodec,\
		$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
			-C $(@D)/$(d) AML_LIBS_STAGING_DIR=$(STAGING_DIR)
	)
endef

define LIBAMCODEC_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0755 $(@D)/amavutils/libamavutils.so $(STAGING_DIR)/usr/lib/libamavutils.so
	$(INSTALL) -D -m 0555 $(@D)/amadec/libamadec.so $(STAGING_DIR)/usr/lib/libamadec.so
	$(INSTALL) -D -m 0555 $(@D)/amcodec/libamcodec.so $(STAGING_DIR)/usr/lib/libamcodec.so
	mkdir -p $(STAGING_DIR)/usr/include/amcodec
	cp -rf $(@D)/amcodec/include/* $(STAGING_DIR)/usr/include/amcodec
endef

define LIBAMCODEC_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/amavutils/libamavutils.so $(TARGET_DIR)/usr/lib/libamavutils.so
	$(INSTALL) -D -m 0555 $(@D)/amadec/libamadec.so $(TARGET_DIR)/usr/lib/libamadec.so
	$(INSTALL) -D -m 0555 $(@D)/amcodec/libamcodec.so $(TARGET_DIR)/usr/lib/libamcodec.so
endef

$(eval $(generic-package))
