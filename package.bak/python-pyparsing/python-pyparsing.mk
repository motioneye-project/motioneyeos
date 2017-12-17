################################################################################
#
# python-pyparsing
#
################################################################################

PYTHON_PYPARSING_VERSION = 2.1.9
PYTHON_PYPARSING_SOURCE = pyparsing-$(PYTHON_PYPARSING_VERSION).tar.gz
PYTHON_PYPARSING_SITE = https://pypi.python.org/packages/87/ee/6f3a94d834c82a5c1a74f2fc77775ff05b5fbbf7d97f844e6fff5e2ff94b
PYTHON_PYPARSING_LICENSE = MIT
PYTHON_PYPARSING_LICENSE_FILES = LICENSE
PYTHON_PYPARSING_SETUP_TYPE = setuptools

$(eval $(python-package))
