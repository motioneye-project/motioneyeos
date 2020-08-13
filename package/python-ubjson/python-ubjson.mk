################################################################################
#
# python-ubjson
#
################################################################################

PYTHON_UBJSON_VERSION = 0.14.0
PYTHON_UBJSON_SOURCE = py-ubjson-$(PYTHON_UBJSON_VERSION).tar.gz
PYTHON_UBJSON_SITE = https://files.pythonhosted.org/packages/10/31/0d8297c33d681aafa3fe900ca072a96d5acb97e79082fbb593e835376c93
PYTHON_UBJSON_LICENSE = Apache-2.0
PYTHON_UBJSON_LICENSE_FILES = LICENSE
PYTHON_UBJSON_SETUP_TYPE = setuptools

$(eval $(python-package))
