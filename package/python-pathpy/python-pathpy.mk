################################################################################
#
# python-pathpy
#
################################################################################

PYTHON_PATHPY_VERSION = 10.5
PYTHON_PATHPY_SOURCE = path.py-$(PYTHON_PATHPY_VERSION).tar.gz
PYTHON_PATHPY_SITE = https://pypi.python.org/packages/a5/7b/7b303dc1b79fc394b67cea351455ec0db8e6ca5d8537687d40cb7c7d70bb
PYTHON_PATHPY_SETUP_TYPE = setuptools
PYTHON_PATHPY_LICENSE = MIT
PYTHON_PATHPY_DEPENDENCIES = host-python-setuptools-scm

$(eval $(python-package))
