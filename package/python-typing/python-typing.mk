################################################################################
#
# python-typing
#
################################################################################

PYTHON_TYPING_VERSION = 3.7.4.1
PYTHON_TYPING_SOURCE = typing-$(PYTHON_TYPING_VERSION).tar.gz
PYTHON_TYPING_SITE = https://files.pythonhosted.org/packages/67/b0/b2ea2bd67bfb80ea5d12a5baa1d12bda002cab3b6c9b48f7708cd40c34bf
PYTHON_TYPING_SETUP_TYPE = setuptools
PYTHON_TYPING_LICENSE = Python-2.0, others
PYTHON_TYPING_LICENSE_FILES = LICENSE

$(eval $(python-package))
$(eval $(host-python-package))
