################################################################################
#
# python-typepy
#
################################################################################

PYTHON_TYPEPY_VERSION = 0.0.20
PYTHON_TYPEPY_SOURCE = typepy-$(PYTHON_TYPEPY_VERSION).tar.gz
PYTHON_TYPEPY_SITE = https://pypi.python.org/packages/88/98/c79a19ae571d713fa0b10bc7e0fe611e53c542720b5a9dd2691ca15b3dd8
PYTHON_TYPEPY_SETUP_TYPE = setuptools
PYTHON_TYPEPY_LICENSE = MIT
PYTHON_TYPEPY_LICENSE_FILES = LICENSE

$(eval $(python-package))
