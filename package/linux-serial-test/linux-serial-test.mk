################################################################################
#
# linux-serial-test
#
################################################################################

LINUX_SERIAL_TEST_VERSION = 9965dad53ba63eea0eea05a0f9d5cb851425fcba
LINUX_SERIAL_TEST_SITE = $(call github,cbrake,linux-serial-test,$(LINUX_SERIAL_TEST_VERSION))
LINUX_SERIAL_TEST_LICENSE = MIT
LINUX_SERIAL_TEST_LICENSE_FILES = LICENSES/MIT

$(eval $(cmake-package))
