################################################################################
#
# python-cchardet
#
################################################################################

PYTHON_CCHARDET_VERSION = 2.1.6
PYTHON_CCHARDET_SOURCE = cchardet-$(PYTHON_CCHARDET_VERSION).tar.gz
PYTHON_CCHARDET_SITE = https://files.pythonhosted.org/packages/41/e6/2e2184a3bc887bfb6e6b97aef5e94af9b8de43806ce14b023ddbbcb0b30d
PYTHON_CCHARDET_SETUP_TYPE = setuptools
PYTHON_CCHARDET_LICENSE = MPL-1.1
PYTHON_CCHARDET_LICENSE_FILES = COPYING

$(eval $(python-package))
