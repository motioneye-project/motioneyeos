#############################################################
#
# python-pyroute2
#
#############################################################

PYTHON_PYROUTE2_VERSION = 0.3.15
PYTHON_PYROUTE2_SOURCE = pyroute2-$(PYTHON_PYROUTE2_VERSION).tar.gz
PYTHON_PYROUTE2_SITE = https://pypi.python.org/packages/source/p/pyroute2
PYTHON_PYROUTE2_LICENSE = Apache-2.0 or GPLv2+
PYTHON_PYROUTE2_LICENSE_FILES = LICENSE.Apache.v2 LICENSE.GPL.v2 README.license.md
PYTHON_PYROUTE2_SETUP_TYPE = distutils

$(eval $(python-package))
