################################################################################
#
# python-pathlib2
#
################################################################################

PYTHON_PATHLIB2_VERSION = 2.2.1
PYTHON_PATHLIB2_SOURCE = pathlib2-$(PYTHON_PATHLIB2_VERSION).tar.gz
PYTHON_PATHLIB2_SITE = https://pypi.python.org/packages/ab/d8/ac7489d50146f29d0a14f65545698f4545d8a6b739b24b05859942048b56
PYTHON_PATHLIB2_LICENSE = MIT
PYTHON_PATHLIB2_LICENSE_FILE = LICENSE.rst
PYTHON_PATHLIB2_SETUP_TYPE = setuptools

$(eval $(python-package))
