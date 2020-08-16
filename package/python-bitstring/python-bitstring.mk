################################################################################
#
# python-bitstring
#
################################################################################

PYTHON_BITSTRING_VERSION = 3.1.6
PYTHON_BITSTRING_SOURCE = bitstring-$(PYTHON_BITSTRING_VERSION).tar.gz
PYTHON_BITSTRING_SITE = https://files.pythonhosted.org/packages/f4/87/fe6f7093088f4396e84c1b5d5dfb08c4840487ad46ff4805b7008c8f5ffc
PYTHON_BITSTRING_SETUP_TYPE = setuptools
PYTHON_BITSTRING_LICENSE = MIT
PYTHON_BITSTRING_LICENSE_FILES = LICENSE

$(eval $(python-package))
