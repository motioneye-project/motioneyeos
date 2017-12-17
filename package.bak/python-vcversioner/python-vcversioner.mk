################################################################################
#
# python-vcversioner
#
################################################################################

PYTHON_VCVERSIONER_VERSION = 2.16.0.0
PYTHON_VCVERSIONER_SOURCE = vcversioner-$(PYTHON_VCVERSIONER_VERSION).tar.gz
PYTHON_VCVERSIONER_SITE = https://pypi.python.org/packages/c5/cc/33162c0a7b28a4d8c83da07bc2b12cee58c120b4a9e8bba31c41c8d35a16
PYTHON_VCVERSIONER_SETUP_TYPE = setuptools
PYTHON_VCVERSIONER_LICENSE = ISC

$(eval $(host-python-package))
