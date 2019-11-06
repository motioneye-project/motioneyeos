################################################################################
#
# linux-serial-test
#
################################################################################

LINUX_SERIAL_TEST_VERSION = 5d11b31d9c9807cd58e53a8628bc6402b6fe7fac
LINUX_SERIAL_TEST_SITE = $(call github,cbrake,linux-serial-test,$(LINUX_SERIAL_TEST_VERSION))
LINUX_SERIAL_TEST_LICENSE = MIT
LINUX_SERIAL_TEST_LICENSE_FILES = LICENSES/MIT

$(eval $(cmake-package))
