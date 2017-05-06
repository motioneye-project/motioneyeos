################################################################################
#
# libloki
#
################################################################################

LIBLOKI_VERSION = 0.1.7
LIBLOKI_SOURCE = loki-$(LIBLOKI_VERSION).tar.bz2
LIBLOKI_SITE = https://sourceforge.net/projects/loki-lib/files/Loki/Loki%20$(LIBLOKI_VERSION)
LIBLOKI_LICENSE = MIT
LIBLOKI_INSTALL_STAGING = YES

ifeq ($(BR2_STATIC_LIBS),y)
LIBLOKI_BUILD_TARGETS += build-static
LIBLOKI_INSTALL_TARGETS += install-static
else ifeq ($(BR2_SHARED_LIBS),y)
LIBLOKI_BUILD_TARGETS += build-shared
LIBLOKI_INSTALL_TARGETS += install-shared
else ifeq ($(BR2_SHARED_STATIC_LIBS),y)
LIBLOKI_BUILD_TARGETS += build-static build-shared
LIBLOKI_INSTALL_TARGETS += install-static install-shared
endif

define LIBLOKI_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		-C $(@D) $(LIBLOKI_BUILD_TARGETS)
endef

define LIBLOKI_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D)/src DESTDIR=$(STAGING_DIR) $(LIBLOKI_INSTALL_TARGETS)
	$(MAKE) -C $(@D)/include DESTDIR=$(STAGING_DIR) install
endef

define LIBLOKI_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D)/src DESTDIR=$(TARGET_DIR) $(LIBLOKI_INSTALL_TARGETS)
endef

$(eval $(generic-package))
