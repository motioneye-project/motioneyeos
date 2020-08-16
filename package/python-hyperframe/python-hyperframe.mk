################################################################################
#
# python-hyperframe
#
################################################################################

PYTHON_HYPERFRAME_VERSION = 5.2.0
PYTHON_HYPERFRAME_SOURCE = hyperframe-$(PYTHON_HYPERFRAME_VERSION).tar.gz
PYTHON_HYPERFRAME_SITE = https://files.pythonhosted.org/packages/e6/7f/9a4834af1010dc1d570d5f394dfd9323a7d7ada7d25586bd299fc4cb0356
PYTHON_HYPERFRAME_SETUP_TYPE = setuptools
PYTHON_HYPERFRAME_LICENSE = MIT
PYTHON_HYPERFRAME_LICENSE_FILES = LICENSE

$(eval $(python-package))
