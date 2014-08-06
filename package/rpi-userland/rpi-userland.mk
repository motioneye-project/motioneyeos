################################################################################
#
# rpi-userland
#
################################################################################

RPI_USERLAND_VERSION = f9e6f9f3def8dc18dc0092cd695ccf53b8ba3efe
RPI_USERLAND_SITE = $(call github,raspberrypi,userland,$(RPI_USERLAND_VERSION))
RPI_USERLAND_LICENSE = BSD-3c
RPI_USERLAND_LICENSE_FILES = LICENCE
RPI_USERLAND_INSTALL_STAGING = YES
RPI_USERLAND_CONF_OPT = -DVMCS_INSTALL_PREFIX=/usr

RPI_USERLAND_PROVIDES = libegl libgles libopenmax libopenvg

define RPI_USERLAND_POST_TARGET_CLEANUP
	rm -Rf $(TARGET_DIR)/usr/src
endef
RPI_USERLAND_POST_INSTALL_TARGET_HOOKS += RPI_USERLAND_POST_TARGET_CLEANUP

$(eval $(cmake-package))
