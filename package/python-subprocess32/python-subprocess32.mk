################################################################################
#
# python-subprocess32
#
################################################################################

PYTHON_SUBPROCESS32_VERSION = 3.5.2
PYTHON_SUBPROCESS32_SOURCE = subprocess32-$(PYTHON_SUBPROCESS32_VERSION).tar.gz
PYTHON_SUBPROCESS32_SITE = https://files.pythonhosted.org/packages/c3/5f/7117737fc7114061837a4f51670d863dd7f7f9c762a6546fa8a0dcfe61c8
PYTHON_SUBPROCESS32_SETUP_TYPE = setuptools
PYTHON_SUBPROCESS32_LICENSE = Python-2.0
PYTHON_SUBPROCESS32_LICENSE_FILES = LICENSE

$(eval $(python-package))
