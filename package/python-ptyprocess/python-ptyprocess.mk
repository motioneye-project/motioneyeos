################################################################################
#
# python-ptyprocess
#
################################################################################

PYTHON_PTYPROCESS_VERSION = 0.6.0
PYTHON_PTYPROCESS_SITE = https://files.pythonhosted.org/packages/7d/2d/e4b8733cf79b7309d84c9081a4ab558c89d8c89da5961bf4ddb050ca1ce0
PYTHON_PTYPROCESS_SOURCE = ptyprocess-$(PYTHON_PTYPROCESS_VERSION).tar.gz
PYTHON_PTYPROCESS_LICENSE = ISC
PYTHON_PTYPROCESS_LICENSE_FILES = LICENSE
PYTHON_PTYPROCESS_SETUP_TYPE = distutils

$(eval $(python-package))
