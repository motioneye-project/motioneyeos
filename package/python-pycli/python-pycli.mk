################################################################################
#
# python-pycli
#
################################################################################

PYTHON_PYCLI_VERSION = devel
PYTHON_PYCLI_SOURCE = pyCLI-$(PYTHON_PYCLI_VERSION).tar.gz
PYTHON_PYCLI_SITE = https://pypi.python.org/packages/source/p/pyCLI/
PYTHON_PYCLI_LICENSE = ISC-like
PYTHON_PYCLI_LICENSE_FILES = lib/cli/__init__.py
PYTHON_PYCLI_SETUP_TYPE = setuptools

$(eval $(python-package))
