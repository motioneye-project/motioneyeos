################################################################################
#
# python-bitstring
#
################################################################################

PYTHON_BITSTRING_VERSION = 3.1.5
PYTHON_BITSTRING_SOURCE = bitstring-$(PYTHON_BITSTRING_VERSION).tar.gz
PYTHON_BITSTRING_SITE = https://github.com/scott-griffiths/bitstring/archive
PYTHON_BITSTRING_SETUP_TYPE = distutils
PYTHON_BITSTRING_LICENSE = MIT
PYTHON_BITSTRING_LICENSE_FILES = LICENSE

$(eval $(python-package))
