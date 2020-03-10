################################################################################
#
# bearssl
#
################################################################################

BEARSSL_VERSION = 0.6
BEARSSL_SITE = https://bearssl.org
BEARSSL_LICENSE = MIT
BEARSSL_LICENSE_FILES = LICENSE.txt
BEARSSL_INSTALL_STAGING = YES

BEARSSL_MAKE_OPTS = \
	$(TARGET_CONFIGURE_OPTS) \
	LDDLL=$(TARGET_CC)

ifeq ($(BR2_SHARED_LIBS)$(BR2_SHARED_STATIC_LIBS),y)
BEARSSL_TARGETS += dll
BEARSSL_MAKE_OPTS += CFLAGS="$(TARGET_CFLAGS) -fPIC"
endif

ifeq ($(BR2_STATIC_LIBS)$(BR2_SHARED_STATIC_LIBS),y)
BEARSSL_TARGETS += lib
endif

define BEARSSL_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(BEARSSL_MAKE_OPTS) -C $(@D) \
		$(BEARSSL_TARGETS)
endef

define BEARSSL_INSTALL_STAGING_CMDS
	mkdir -p $(STAGING_DIR)/usr/include
	cp -dpfr $(@D)/inc/*.h $(STAGING_DIR)/usr/include
	mkdir -p $(STAGING_DIR)/usr/lib
	cp -dpfr $(@D)/build/lib* $(STAGING_DIR)/usr/lib
endef

define BEARSSL_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/lib
	cp -dpfr $(@D)/build/lib* $(TARGET_DIR)/usr/lib
endef

$(eval $(generic-package))
