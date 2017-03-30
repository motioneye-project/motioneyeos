################################################################################
#
# python-chardet
#
################################################################################

PYTHON_CHARDET_VERSION = 2.3.0
PYTHON_CHARDET_SOURCE = chardet-$(PYTHON_CHARDET_VERSION).tar.gz
PYTHON_CHARDET_SITE = https://pypi.python.org/packages/7d/87/4e3a3f38b2f5c578ce44f8dc2aa053217de9f0b6d737739b0ddac38ed237
PYTHON_CHARDET_SETUP_TYPE = setuptools
PYTHON_CHARDET_LICENSE = LGPL-2.1+
PYTHON_CHARDET_LICENSE_FILES = LICENSE

$(eval $(python-package))
