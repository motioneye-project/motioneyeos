################################################################################
#
# python-pigpio
#
################################################################################

PYTHON_PIGPIO_VERSION = 1.44
PYTHON_PIGPIO_SOURCE = pigpio-$(PYTHON_PIGPIO_VERSION).tar.gz
PYTHON_PIGPIO_SITE = https://files.pythonhosted.org/packages/8a/30/16b92e0fede5c543f56875c11f8658457af24991277aee693e0e66a6c967
PYTHON_PIGPIO_SETUP_TYPE = setuptools
PYTHON_PIGPIO_LICENSE = Unlicense

$(eval $(python-package))
