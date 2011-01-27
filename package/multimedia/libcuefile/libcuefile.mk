################################################################################
#
# libcuefile
#
################################################################################

LIBCUEFILE_VERSION = r453
LIBCUEFILE_SITE = http://files.musepack.net/source
LIBCUEFILE_SOURCE = libcuefile_$(LIBCUEFILE_VERSION).tar.gz
LIBCUEFILE_INSTALL_STAGING = YES

define LIBCUEFILE_INSTALL_STAGING_INCLUDES
	cp -r $(@D)/include $(STAGING_DIR)/usr
endef

define LIBCUEFILE_INSTALL_TARGET_INCLUDES
	cp -r $(@D)/include $(TARGET_DIR)/usr
endef

LIBCUEFILE_POST_INSTALL_STAGING_HOOKS += LIBCUEFILE_INSTALL_STAGING_INCLUDES
LIBCUEFILE_POST_INSTALL_TARGET_HOOKS += LIBCUEFILE_INSTALL_TARGET_INCLUDES

$(eval $(call CMAKETARGETS,package/multimedia,libcuefile))
