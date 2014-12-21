################################################################################
#
# python-cheetah
#
################################################################################

PYTHON_CHEETAH_VERSION = 2.4.4
PYTHON_CHEETAH_SOURCE = Cheetah-$(PYTHON_CHEETAH_VERSION).tar.gz
PYTHON_CHEETAH_SITE = http://pypi.python.org/packages/source/C/Cheetah
PYTHON_CHEETAH_LICENSE = MIT
PYTHON_CHEETAH_SETUP_TYPE = setuptools

$(eval $(python-package))
