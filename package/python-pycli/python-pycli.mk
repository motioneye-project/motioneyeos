################################################################################
#
# python-pycli
#
################################################################################

PYTHON_PYCLI_VERSION = 2.0.3
PYTHON_PYCLI_SOURCE = pyCLI-$(PYTHON_PYCLI_VERSION).tar.gz
PYTHON_PYCLI_SITE = https://pypi.python.org/packages/95/fc/b2d86a5fbdac4072bcf70b01674b612e1a13026f54962c878fe3eca36fd1
PYTHON_PYCLI_LICENSE = ISC-like
PYTHON_PYCLI_LICENSE_FILES = lib/cli/__init__.py
PYTHON_PYCLI_SETUP_TYPE = setuptools

$(eval $(python-package))
