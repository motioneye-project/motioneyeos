################################################################################
#
# python-typepy
#
################################################################################

PYTHON_TYPEPY_VERSION = 0.0.14
PYTHON_TYPEPY_SOURCE = typepy-$(PYTHON_TYPEPY_VERSION).tar.gz
PYTHON_TYPEPY_SITE = https://pypi.python.org/packages/5c/1a/3836e06f2f476e785006bb0f9305160577586a8d4ae2a017fc778f580344
PYTHON_TYPEPY_SETUP_TYPE = setuptools
PYTHON_TYPEPY_LICENSE = MIT
PYTHON_TYPEPY_LICENSE_FILES = LICENSE

$(eval $(python-package))
