################################################################################
#
# python-dataproperty
#
################################################################################

PYTHON_DATAPROPERTY_VERSION = 0.3.1
PYTHON_DATAPROPERTY_SOURCE = DataProperty-$(PYTHON_DATAPROPERTY_VERSION).tar.gz
PYTHON_DATAPROPERTY_SITE = https://pypi.python.org/packages/94/84/a78a208b4fe3001e8fa1dc553122e3f27a807f26fee097f20714d6def70b
PYTHON_DATAPROPERTY_SETUP_TYPE = setuptools
PYTHON_DATAPROPERTY_LICENSE = MIT
PYTHON_DATAPROPERTY_LICENSE_FILES = LICENSE

$(eval $(python-package))
