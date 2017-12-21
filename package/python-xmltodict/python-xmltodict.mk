################################################################################
#
# python-xmltodict
#
################################################################################

PYTHON_XMLTODICT_VERSION = 0.11.0
PYTHON_XMLTODICT_SOURCE = xmltodict-$(PYTHON_XMLTODICT_VERSION).tar.gz
PYTHON_XMLTODICT_SITE = https://pypi.python.org/packages/57/17/a6acddc5f5993ea6eaf792b2e6c3be55e3e11f3b85206c818572585f61e1
PYTHON_XMLTODICT_SETUP_TYPE = setuptools
PYTHON_XMLTODICT_LICENSE = MIT
PYTHON_XMLTODICT_LICENSE_FILES = LICENSE

$(eval $(python-package))
