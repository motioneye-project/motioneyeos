################################################################################
#
# python-pygments
#
################################################################################

PYTHON_PYGMENTS_VERSION = 2.4.2
PYTHON_PYGMENTS_SOURCE = Pygments-$(PYTHON_PYGMENTS_VERSION).tar.gz
PYTHON_PYGMENTS_SITE = https://files.pythonhosted.org/packages/7e/ae/26808275fc76bf2832deb10d3a3ed3107bc4de01b85dcccbe525f2cd6d1e
PYTHON_PYGMENTS_LICENSE = BSD-2-Clause
PYTHON_PYGMENTS_LICENSE_FILES = LICENSE
PYTHON_PYGMENTS_SETUP_TYPE = setuptools

$(eval $(python-package))
