################################################################################
#
# python-dataproperty
#
################################################################################

PYTHON_DATAPROPERTY_VERSION = 0.48.1
PYTHON_DATAPROPERTY_SOURCE = DataProperty-$(PYTHON_DATAPROPERTY_VERSION).tar.gz
PYTHON_DATAPROPERTY_SITE = https://files.pythonhosted.org/packages/2e/b5/d644919656adf4e7ae94b5479a3fec7497060c89292c335b27e59d66706f
PYTHON_DATAPROPERTY_SETUP_TYPE = setuptools
PYTHON_DATAPROPERTY_LICENSE = MIT
PYTHON_DATAPROPERTY_LICENSE_FILES = LICENSE

$(eval $(python-package))
