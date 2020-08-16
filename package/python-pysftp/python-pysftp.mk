################################################################################
#
# python-pysftp
#
################################################################################

PYTHON_PYSFTP_VERSION = 0.2.9
PYTHON_PYSFTP_SOURCE = pysftp-$(PYTHON_PYSFTP_VERSION).tar.gz
PYTHON_PYSFTP_SITE = https://files.pythonhosted.org/packages/36/60/45f30390a38b1f92e0a8cf4de178cd7c2bc3f874c85430e40ccf99df8fe7
PYTHON_PYSFTP_SETUP_TYPE = setuptools
PYTHON_PYSFTP_LICENSE = BSD-3-Clause
PYTHON_PYSFTP_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
