################################################################################
#
# python-pigpio
#
################################################################################

PYTHON_PIGPIO_VERSION = 1.40.post1
PYTHON_PIGPIO_SOURCE = pigpio-$(PYTHON_PIGPIO_VERSION).tar.gz
PYTHON_PIGPIO_SITE = https://files.pythonhosted.org/packages/da/91/80c893c398bc6805592f44267bbf4bf88323de3db0f5e8f94b0fa8e28426
PYTHON_PIGPIO_SETUP_TYPE = setuptools
PYTHON_PIGPIO_LICENSE = Unlicense

$(eval $(python-package))
