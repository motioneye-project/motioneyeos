################################################################################
#
# python-portend
#
################################################################################

PYTHON_PORTEND_VERSION = 1.8
PYTHON_PORTEND_SOURCE = portend-$(PYTHON_PORTEND_VERSION).tar.gz
PYTHON_PORTEND_SITE = https://pypi.python.org/packages/3f/37/f3ab6c4a00632d53d7dfb74ba4a695e86605b92b0a94bd41fa443b60ccb6
PYTHON_PORTEND_LICENSE = MIT
PYTHON_PORTEND_SETUP_TYPE = setuptools
PYTHON_PORTEND_DEPENDENCIES = host-python-setuptools-scm

$(eval $(python-package))
