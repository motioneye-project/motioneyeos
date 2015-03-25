################################################################################
#
# libiio
#
################################################################################

LIBIIO_VERSION = 0.5
LIBIIO_SITE = $(call github,analogdevicesinc,libiio,v$(LIBIIO_VERSION))
LIBIIO_INSTALL_STAGING = YES
LIBIIO_LICENSE = LGPLv2.1+
LIBIIO_LICENSE_FILES = COPYING

LIBIIO_CONF_OPTS = -DENABLE_IPV6=ON \
	-DWITH_LOCAL_BACKEND=$(if $(BR2_PACKAGE_LIBIIO_LOCAL_BACKEND),ON,OFF) \
	-DWITH_TESTS=$(if $(BR2_PACKAGE_LIBIIO_TESTS),ON,OFF) \
	-DWITH_DOC=OFF

ifeq ($(BR2_PACKAGE_LIBIIO_NETWORK_BACKEND),y)
LIBIIO_DEPENDENCIES += libxml2
LIBIIO_CONF_OPTS += -DWITH_NETWORK_BACKEND=ON
else
LIBIIO_CONF_OPTS += -DWITH_NETWORK_BACKEND=OFF
endif

ifeq ($(BR2_PACKAGE_LIBIIO_IIOD),y)
LIBIIO_DEPENDENCIES += host-flex host-bison
LIBIIO_CONF_OPTS += -DWITH_IIOD=ON
else
LIBIIO_CONF_OPTS += -DWITH_IIOD=OFF
endif

# Avahi support in libiio requires avahi-client, which needs avahi-daemon
ifeq ($(BR2_PACKAGE_AVAHI)$(BR2_PACKAGE_AVAHI_DAEMON),yy)
LIBIIO_DEPENDENCIES += avahi
endif

ifeq ($(BR2_PACKAGE_LIBIIO_BINDINGS_PYTHON),y)
LIBIIO_DEPENDENCIES += python
LIBIIO_CONF_OPTS += -DPYTHON_BINDINGS=ON
else
LIBIIO_CONF_OPTS += -DPYTHON_BINDINGS=OFF
endif

ifeq ($(BR2_PACKAGE_LIBIIO_BINDINGS_CSHARP),y)
define LIBIIO_INSTALL_CSHARP_BINDINGS_TO_TARGET
	rm $(TARGET_DIR)/usr/lib/cli/libiio-sharp-$(LIBIIO_VERSION)/libiio-sharp.dll.mdb
	$(HOST_DIR)/usr/bin/gacutil -root $(TARGET_DIR)/usr/lib -i \
		$(TARGET_DIR)/usr/lib/cli/libiio-sharp-$(LIBIIO_VERSION)/libiio-sharp.dll
endef
define LIBIIO_INSTALL_CSHARP_BINDINGS_TO_STAGING
	$(HOST_DIR)/usr/bin/gacutil -root $(STAGING_DIR)/usr/lib -i \
		$(STAGING_DIR)/usr/lib/cli/libiio-sharp-$(LIBIIO_VERSION)/libiio-sharp.dll
endef
LIBIIO_POST_INSTALL_TARGET_HOOKS += LIBIIO_INSTALL_CSHARP_BINDINGS_TO_TARGET
LIBIIO_POST_INSTALL_STAGING_HOOKS += LIBIIO_INSTALL_CSHARP_BINDINGS_TO_STAGING
LIBIIO_DEPENDENCIES += mono
LIBIIO_CONF_OPTS += -DCSHARP_BINDINGS=ON
else
LIBIIO_CONF_OPTS += -DCSHARP_BINDINGS=OFF
endif

ifeq ($(BR2_PACKAGE_LIBIIO_IIOD),y)
define LIBIIO_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/libiio/S99iiod \
		$(TARGET_DIR)/etc/init.d/S99iiod
endef
define LIBIIO_INSTALL_INIT_SYSTEMD
	$(INSTALL) -d $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	$(INSTALL) -D -m 0644 $(@D)/debian/iiod.service \
		$(TARGET_DIR)/usr/lib/systemd/system/iiod.service
	ln -fs ../../../../usr/lib/systemd/system/iiod.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/iiod.service
endef
endif

$(eval $(cmake-package))
