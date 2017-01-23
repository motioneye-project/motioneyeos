################################################################################
#
# rpi-userland
#
################################################################################

RPI_USERLAND_VERSION = c139376e9bc6fbd93f777c7fc3c7d7cf2cc35122
RPI_USERLAND_SITE = $(call github,raspberrypi,userland,$(RPI_USERLAND_VERSION))
RPI_USERLAND_LICENSE = BSD-3c
RPI_USERLAND_LICENSE_FILES = LICENCE
RPI_USERLAND_INSTALL_STAGING = YES
RPI_USERLAND_CONF_OPTS = -DVMCS_INSTALL_PREFIX=/usr \
	-DCMAKE_C_FLAGS="$(TARGET_CFLAGS) \
		-DVCFILED_LOCKFILE=\\\"/var/run/vcfiled.pid\\\""

RPI_USERLAND_PROVIDES = libegl libgles libopenmax libopenvg

ifeq ($(BR2_PACKAGE_RPI_USERLAND_START_VCFILED),y)
define RPI_USERLAND_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/rpi-userland/S94vcfiled \
		$(TARGET_DIR)/etc/init.d/S94vcfiled
endef
define RPI_USERLAND_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/rpi-userland/vcfiled.service \
		$(TARGET_DIR)/usr/lib/systemd/system/vcfiled.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -sf ../../../../usr/lib/systemd/system/vcfiled.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/vcfiled.service
endef
endif

ifeq ($(BR2_PACKAGE_RPI_USERLAND_HELLO),y)

RPI_USERLAND_CONF_OPTS += -DALL_APPS=ON

define RPI_USERLAND_EXTRA_LIBS_TARGET
	$(INSTALL) -m 0644 -D \
		$(@D)/build/lib/libilclient.so \
		$(TARGET_DIR)/usr/lib/libilclient.so
endef
RPI_USERLAND_POST_INSTALL_TARGET_HOOKS += RPI_USERLAND_EXTRA_LIBS_TARGET

define RPI_USERLAND_EXTRA_LIBS_STAGING
	$(INSTALL) -m 0644 -D \
		$(@D)/build/lib/libilclient.so \
		$(STAGING_DIR)/usr/lib/libilclient.so
endef
RPI_USERLAND_POST_INSTALL_STAGING_HOOKS += RPI_USERLAND_EXTRA_LIBS_STAGING

else

RPI_USERLAND_CONF_OPTS += -DALL_APPS=OFF

endif # BR2_PACKAGE_RPI_USERLAND_HELLO

define RPI_USERLAND_POST_TARGET_CLEANUP
	rm -f $(TARGET_DIR)/etc/init.d/vcfiled
	rm -f $(TARGET_DIR)/usr/share/install/vcfiled
	rmdir --ignore-fail-on-non-empty $(TARGET_DIR)/usr/share/install
	rm -Rf $(TARGET_DIR)/usr/src
endef
RPI_USERLAND_POST_INSTALL_TARGET_HOOKS += RPI_USERLAND_POST_TARGET_CLEANUP

$(eval $(cmake-package))
