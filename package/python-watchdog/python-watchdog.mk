################################################################################
#
# python-watchdog
#
################################################################################

PYTHON_WATCHDOG_VERSION = 0.9.0
PYTHON_WATCHDOG_SOURCE = watchdog-$(PYTHON_WATCHDOG_VERSION).tar.gz
PYTHON_WATCHDOG_SITE = https://pypi.python.org/packages/bb/e3/5a55d48a29300160779f0a0d2776d17c1b762a2039b36de528b093b87d5b
PYTHON_WATCHDOG_SETUP_TYPE = setuptools
PYTHON_WATCHDOG_LICENSE = Apache-2.0
PYTHON_WATCHDOG_LICENSE_FILES = LICENSE COPYING

$(eval $(python-package))
