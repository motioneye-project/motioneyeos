################################################################################
#
# python-pycryptodomex
#
################################################################################

PYTHON_PYCRYPTODOMEX_VERSION = 3.6.6
PYTHON_PYCRYPTODOMEX_SOURCE = pycryptodomex-$(PYTHON_PYCRYPTODOMEX_VERSION).tar.gz
PYTHON_PYCRYPTODOMEX_SITE = https://files.pythonhosted.org/packages/95/10/f3bd758050da1c08ea30c8b4daf9ff895f306b780f07430fcc9b38722e1b
PYTHON_PYCRYPTODOMEX_SETUP_TYPE = setuptools
PYTHON_PYCRYPTODOMEX_LICENSE = \
	BSD-2-Clause, \
	Public Domain (pycrypto original code), \
	OCB patent license (OCB mode)
PYTHON_PYCRYPTODOMEX_LICENSE_FILES = LICENSE.rst Doc/LEGAL/COPYRIGHT.pycrypto

$(eval $(python-package))
