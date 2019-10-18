################################################################################
#
# python-webpy
#
################################################################################

PYTHON_WEBPY_VERSION = 0.40
PYTHON_WEBPY_SOURCE = web.py-$(PYTHON_WEBPY_VERSION).tar.gz
PYTHON_WEBPY_SITE = https://files.pythonhosted.org/packages/e3/23/ed84b174add09153329c6357984c8433e2f350de91c3859fa48c3cdbf7dc
PYTHON_WEBPY_SETUP_TYPE = setuptools
PYTHON_WEBPY_LICENSE = Public Domain
PYTHON_WEBPY_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
