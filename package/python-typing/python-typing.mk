################################################################################
#
# python-typing
#
################################################################################

PYTHON_TYPING_VERSION = 3.6.6
PYTHON_TYPING_SOURCE = typing-$(PYTHON_TYPING_VERSION).tar.gz
PYTHON_TYPING_SITE = https://files.pythonhosted.org/packages/bf/9b/2bf84e841575b633d8d91ad923e198a415e3901f228715524689495b4317
PYTHON_TYPING_SETUP_TYPE = setuptools
PYTHON_TYPING_LICENSE = Python-2.0, others
PYTHON_TYPING_LICENSE_FILES = LICENSE

$(eval $(python-package))
