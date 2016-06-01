################################################################################
#
# python-argh
#
################################################################################

PYTHON_ARGH_VERSION = 0.26.1
PYTHON_ARGH_SOURCE = argh-$(PYTHON_ARGH_VERSION).tar.gz
PYTHON_ARGH_SITE = https://pypi.python.org/packages/14/7f/794a7f4a48cba505a4b4c714f81fed844a3a5f7340b171f448711439b09e
PYTHON_ARGH_SETUP_TYPE = setuptools
PYTHON_ARGH_LICENSE = LGPLv3+
PYTHON_ARGH_LICENSE_FILES = README.rst

$(eval $(python-package))
