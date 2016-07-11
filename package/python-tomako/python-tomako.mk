################################################################################
#
# python-tomako
#
################################################################################

PYTHON_TOMAKO_VERSION = 0.1.0.post1
PYTHON_TOMAKO_SOURCE = tomako-$(PYTHON_TOMAKO_VERSION).tar.gz
PYTHON_TOMAKO_SITE = https://pypi.python.org/packages/30/64/e174248281cb2fa8f5bce955d4bd49b253e622bb540a6001e48dec378a07
PYTHON_TOMAKO_SETUP_TYPE = setuptools
PYTHON_TOMAKO_LICENSE = MIT
PYTHON_TOMAKO_LICENSE_FILES = LICENSE

$(eval $(python-package))
