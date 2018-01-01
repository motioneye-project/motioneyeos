################################################################################
#
# ev3dev Linux drivers
#
################################################################################

EV3DEV_LINUX_DRIVERS_VERSION = 0e551eb25ae8600c1f178814781bfb42dc835496
EV3DEV_LINUX_DRIVERS_SITE = $(call github,ev3dev,lego-linux-drivers,$(EV3DEV_LINUX_DRIVERS_VERSION))
EV3DEV_LINUX_DRIVERS_LICENSE = GPL-2.0

$(eval $(generic-package))
