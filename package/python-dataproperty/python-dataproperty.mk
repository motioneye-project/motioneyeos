################################################################################
#
# python-dataproperty
#
################################################################################

PYTHON_DATAPROPERTY_VERSION = 0.43.1
PYTHON_DATAPROPERTY_SOURCE = DataProperty-$(PYTHON_DATAPROPERTY_VERSION).tar.gz
PYTHON_DATAPROPERTY_SITE = https://files.pythonhosted.org/packages/95/68/fb3498145a106f700ff304158b6d0f0c76eb3001ee5129a4f16c9846b338
PYTHON_DATAPROPERTY_SETUP_TYPE = setuptools
PYTHON_DATAPROPERTY_LICENSE = MIT
PYTHON_DATAPROPERTY_LICENSE_FILES = LICENSE

$(eval $(python-package))
