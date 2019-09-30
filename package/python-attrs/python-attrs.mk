################################################################################
#
# python-attrs
#
################################################################################

PYTHON_ATTRS_VERSION = 19.1.0
PYTHON_ATTRS_SOURCE = attrs-$(PYTHON_ATTRS_VERSION).tar.gz
PYTHON_ATTRS_SITE = https://files.pythonhosted.org/packages/cc/d9/931a24cc5394f19383fbbe3e1147a0291276afa43a0dc3ed0d6cd9fda813
PYTHON_ATTRS_SETUP_TYPE = setuptools
PYTHON_ATTRS_LICENSE = MIT
PYTHON_ATTRS_LICENSE_FILES = LICENSE

$(eval $(python-package))
