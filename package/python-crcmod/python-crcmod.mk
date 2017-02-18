################################################################################
#
# python-crcmod
#
################################################################################

PYTHON_CRCMOD_VERSION = 1.7
PYTHON_CRCMOD_SOURCE = crcmod-$(PYTHON_CRCMOD_VERSION).tar.gz
PYTHON_CRCMOD_SITE = https://pypi.python.org/packages/6b/b0/e595ce2a2527e169c3bcd6c33d2473c1918e0b7f6826a043ca1245dd4e5b
PYTHON_CRCMOD_SETUP_TYPE = distutils
PYTHON_CRCMOD_LICENSE = MIT
PYTHON_CRCMOD_LICENSE_FILES = LICENSE

$(eval $(python-package))
