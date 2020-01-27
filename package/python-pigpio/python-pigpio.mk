################################################################################
#
# python-pigpio
#
################################################################################

PYTHON_PIGPIO_VERSION = 1.45
PYTHON_PIGPIO_SOURCE = pigpio-$(PYTHON_PIGPIO_VERSION).tar.gz
PYTHON_PIGPIO_SITE = https://files.pythonhosted.org/packages/33/48/db99b4ccc9f895827aa96d35404bae803b31555cdef0c1356ad3b6fca2d5
PYTHON_PIGPIO_SETUP_TYPE = setuptools
PYTHON_PIGPIO_LICENSE = Unlicense

$(eval $(python-package))
