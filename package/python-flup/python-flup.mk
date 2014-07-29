################################################################################
#
# python-flup
#
################################################################################

PYTHON_FLUP_VERSION = 1.0.3.dev-20110405
PYTHON_FLUP_SOURCE = flup-$(PYTHON_FLUP_VERSION).tar.gz
PYTHON_FLUP_SITE = http://pypi.python.org/packages/source/f/flup

PYTHON_FLUP_LICENSE = BSD-2c, MIT

PYTHON_FLUP_SETUP_TYPE = setuptools

$(eval $(python-package))
