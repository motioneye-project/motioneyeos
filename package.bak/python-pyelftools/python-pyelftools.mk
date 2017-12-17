################################################################################
#
# python-pyelftools
#
################################################################################

PYTHON_PYELFTOOLS_VERSION = 0.24
PYTHON_PYELFTOOLS_SOURCE = pyelftools-$(PYTHON_PYELFTOOLS_VERSION).tar.gz
PYTHON_PYELFTOOLS_SITE = https://pypi.python.org/packages/ba/78/d4a186a2e38731286c99dc3e3ca8123b6f55cf2e28608e8daf2d84b65494
PYTHON_PYELFTOOLS_LICENSE = Public domain
PYTHON_PYELFTOOLS_LICENSE_FILES = LICENSE
PYTHON_PYELFTOOLS_SETUP_TYPE = distutils

$(eval $(python-package))
