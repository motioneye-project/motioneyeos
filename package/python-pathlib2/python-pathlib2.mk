################################################################################
#
# python-pathlib2
#
################################################################################

PYTHON_PATHLIB2_VERSION = 2.3.2
PYTHON_PATHLIB2_SOURCE = pathlib2-$(PYTHON_PATHLIB2_VERSION).tar.gz
PYTHON_PATHLIB2_SITE = https://files.pythonhosted.org/packages/db/a8/7d6439c1aec525ed70810abee5b7d7f3aa35347f59bc28343e8f62019aa2
PYTHON_PATHLIB2_LICENSE = MIT
PYTHON_PATHLIB2_LICENSE_FILES = LICENSE.rst
PYTHON_PATHLIB2_SETUP_TYPE = setuptools

$(eval $(python-package))
