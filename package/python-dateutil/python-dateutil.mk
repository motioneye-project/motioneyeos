################################################################################
#
# python-dateutil
#
################################################################################

PYTHON_DATEUTIL_VERSION = 2.5.3
PYTHON_DATEUTIL_SOURCE = python-dateutil-$(PYTHON_DATEUTIL_VERSION).tar.gz
PYTHON_DATEUTIL_SITE = https://pypi.python.org/packages/3e/f5/aad82824b369332a676a90a8c0d1e608b17e740bbb6aeeebca726f17b902
PYTHON_DATEUTIL_SETUP_TYPE = setuptools
PYTHON_DATEUTIL_LICENSE = BSD-3c
PYTHON_DATEUTIL_LICENSE_FILES = LICENSE

$(eval $(python-package))
