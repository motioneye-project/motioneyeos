################################################################################
#
# python-pyasn1-modules
#
################################################################################

PYTHON_PYASN1_MODULES_VERSION = 0.2.2
PYTHON_PYASN1_MODULES_SOURCE = pyasn1-modules-$(PYTHON_PYASN1_MODULES_VERSION).tar.gz
PYTHON_PYASN1_MODULES_SITE = https://files.pythonhosted.org/packages/37/33/74ebdc52be534e683dc91faf263931bc00ae05c6073909fde53999088541
PYTHON_PYASN1_MODULES_SETUP_TYPE = setuptools
PYTHON_PYASN1_MODULES_LICENSE = BSD-2-Clause
PYTHON_PYASN1_MODULES_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
