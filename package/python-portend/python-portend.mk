################################################################################
#
# python-portend
#
################################################################################

PYTHON_PORTEND_VERSION = 2.5
PYTHON_PORTEND_SOURCE = portend-$(PYTHON_PORTEND_VERSION).tar.gz
PYTHON_PORTEND_SITE = https://files.pythonhosted.org/packages/2c/59/948666fc2455ae471efd40cb2a9a990f5f6f2354a9a6b228e29b9fb4a307
PYTHON_PORTEND_LICENSE = MIT
PYTHON_PORTEND_LICENSE_FILES = LICENSE
PYTHON_PORTEND_SETUP_TYPE = setuptools
PYTHON_PORTEND_DEPENDENCIES = host-python-setuptools-scm

$(eval $(python-package))
