################################################################################
#
# python-tomako
#
################################################################################

PYTHON_TOMAKO_VERSION = 0.1.0
PYTHON_TOMAKO_SOURCE = tomako-$(PYTHON_TOMAKO_VERSION).tar.gz
PYTHON_TOMAKO_SITE = https://pypi.python.org/packages/66/6f/de5449d401ca6953691c765d7465941e772cf99a3547646edc58cdca452d
PYTHON_TOMAKO_SETUP_TYPE = setuptools
PYTHON_TOMAKO_LICENSE = MIT

$(eval $(python-package))
