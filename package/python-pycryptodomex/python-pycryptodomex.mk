################################################################################
#
# python-pycryptodomex
#
################################################################################

PYTHON_PYCRYPTODOMEX_VERSION = 3.7.1
PYTHON_PYCRYPTODOMEX_SOURCE = pycryptodomex-$(PYTHON_PYCRYPTODOMEX_VERSION).tar.gz
PYTHON_PYCRYPTODOMEX_SITE = https://files.pythonhosted.org/packages/f6/be/9f65b7db183628bdb36401105a3fc9f1688909f5184c115902a7bdd333bd
PYTHON_PYCRYPTODOMEX_SETUP_TYPE = setuptools
PYTHON_PYCRYPTODOMEX_LICENSE = \
	BSD-2-Clause, \
	Public Domain (pycrypto original code), \
	OCB patent license (OCB mode)
PYTHON_PYCRYPTODOMEX_LICENSE_FILES = LICENSE.rst Doc/LEGAL/COPYRIGHT.pycrypto

$(eval $(python-package))
