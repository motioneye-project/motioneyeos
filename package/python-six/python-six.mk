################################################################################
#
# python-six
#
################################################################################

PYTHON_SIX_VERSION = 1.13.0
PYTHON_SIX_SOURCE = six-$(PYTHON_SIX_VERSION).tar.gz
PYTHON_SIX_SITE = https://files.pythonhosted.org/packages/94/3e/edcf6fef41d89187df7e38e868b2dd2182677922b600e880baad7749c865
PYTHON_SIX_SETUP_TYPE = setuptools
PYTHON_SIX_LICENSE = MIT
PYTHON_SIX_LICENSE_FILES = LICENSE

$(eval $(python-package))
$(eval $(host-python-package))
