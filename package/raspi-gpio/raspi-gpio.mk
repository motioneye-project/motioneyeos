################################################################################
#
# raspi-gpio
#
################################################################################

RASPI_GPIO_VERSION = 4edfde183ff3ac9ed66cdc015ae25e45f3a5502d
RASPI_GPIO_SITE = $(call github,RPi-Distro,raspi-gpio,$(RASPI_GPIO_VERSION))
RASPI_GPIO_LICENSE = BSD-3-Clause
RASPI_GPIO_LICENSE_FILES = LICENSE

$(eval $(autotools-package))
