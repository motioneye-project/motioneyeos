################################################################################
#
# python-pathlib2
#
################################################################################

PYTHON_PATHLIB2_VERSION = 2.3.5
PYTHON_PATHLIB2_SOURCE = pathlib2-$(PYTHON_PATHLIB2_VERSION).tar.gz
PYTHON_PATHLIB2_SITE = https://files.pythonhosted.org/packages/94/d8/65c86584e7e97ef824a1845c72bbe95d79f5b306364fa778a3c3e401b309
PYTHON_PATHLIB2_LICENSE = MIT
PYTHON_PATHLIB2_LICENSE_FILES = LICENSE.rst
PYTHON_PATHLIB2_SETUP_TYPE = setuptools

$(eval $(python-package))
