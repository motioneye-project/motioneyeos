################################################################################
#
# python-itsdangerous
#
################################################################################

PYTHON_ITSDANGEROUS_VERSION = 1.1.0
PYTHON_ITSDANGEROUS_SOURCE = itsdangerous-$(PYTHON_ITSDANGEROUS_VERSION).tar.gz
PYTHON_ITSDANGEROUS_SITE = https://files.pythonhosted.org/packages/68/1a/f27de07a8a304ad5fa817bbe383d1238ac4396da447fa11ed937039fa04b
PYTHON_ITSDANGEROUS_SETUP_TYPE = setuptools
PYTHON_ITSDANGEROUS_LICENSE = BSD-3-Clause
PYTHON_ITSDANGEROUS_LICENSE_FILES = LICENSE.rst

$(eval $(python-package))
