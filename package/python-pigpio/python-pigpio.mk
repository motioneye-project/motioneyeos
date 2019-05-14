################################################################################
#
# python-pigpio
#
################################################################################

PYTHON_PIGPIO_VERSION = 1.42
PYTHON_PIGPIO_SOURCE = pigpio-$(PYTHON_PIGPIO_VERSION).tar.gz
PYTHON_PIGPIO_SITE = https://files.pythonhosted.org/packages/f6/c1/73d7b4287e2edc7e06ac34a4ec0c73d4758ba755a8d2ecc2aaf57bf7d54c
PYTHON_PIGPIO_SETUP_TYPE = setuptools
PYTHON_PIGPIO_LICENSE = Unlicense

$(eval $(python-package))
