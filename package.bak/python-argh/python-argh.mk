################################################################################
#
# python-argh
#
################################################################################

PYTHON_ARGH_VERSION = 0.26.2
PYTHON_ARGH_SOURCE = argh-$(PYTHON_ARGH_VERSION).tar.gz
PYTHON_ARGH_SITE = https://pypi.python.org/packages/e3/75/1183b5d1663a66aebb2c184e0398724b624cecd4f4b679cb6e25de97ed15
PYTHON_ARGH_SETUP_TYPE = setuptools
PYTHON_ARGH_LICENSE = LGPLv3+
PYTHON_ARGH_LICENSE_FILES = README.rst

$(eval $(python-package))
