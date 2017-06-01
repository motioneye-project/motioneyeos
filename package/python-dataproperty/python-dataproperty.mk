################################################################################
#
# python-dataproperty
#
################################################################################

PYTHON_DATAPROPERTY_VERSION = 0.22.0
PYTHON_DATAPROPERTY_SOURCE = DataProperty-$(PYTHON_DATAPROPERTY_VERSION).tar.gz
PYTHON_DATAPROPERTY_SITE = https://pypi.python.org/packages/ed/00/091f46cc81869b925d4001300bef31ea2224436c494d1de7145d4bb56df1
PYTHON_DATAPROPERTY_SETUP_TYPE = setuptools
PYTHON_DATAPROPERTY_LICENSE = MIT
PYTHON_DATAPROPERTY_LICENSE_FILES = LICENSE

$(eval $(python-package))
