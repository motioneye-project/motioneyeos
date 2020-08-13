################################################################################
#
# python-pigpio
#
################################################################################

PYTHON_PIGPIO_VERSION = 1.46
PYTHON_PIGPIO_SOURCE = pigpio-$(PYTHON_PIGPIO_VERSION).tar.gz
PYTHON_PIGPIO_SITE = https://files.pythonhosted.org/packages/5d/ad/75966e59159a64f3d496bf730c54d6222d69a72261f1556232e25ce59edf
PYTHON_PIGPIO_SETUP_TYPE = setuptools
PYTHON_PIGPIO_LICENSE = Unlicense

$(eval $(python-package))
