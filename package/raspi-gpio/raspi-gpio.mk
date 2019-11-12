################################################################################
#
# raspi-gpio
#
################################################################################

RASPI_GPIO_VERSION = 2eaa8b8755a550e34d07c898b90b0d9b3d66fd81
RASPI_GPIO_SITE = $(call github,RPi-Distro,raspi-gpio,$(RASPI_GPIO_VERSION))
RASPI_GPIO_LICENSE = BSD-3-Clause
RASPI_GPIO_LICENSE_FILES = LICENSE

$(eval $(autotools-package))
