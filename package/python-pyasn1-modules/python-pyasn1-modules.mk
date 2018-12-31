################################################################################
#
# python-pyasn1-modules
#
################################################################################

PYTHON_PYASN1_MODULES_VERSION = 0.2.3
PYTHON_PYASN1_MODULES_SOURCE = pyasn1-modules-$(PYTHON_PYASN1_MODULES_VERSION).tar.gz
PYTHON_PYASN1_MODULES_SITE = https://files.pythonhosted.org/packages/c8/0e/3fe59edc782faf8b429f4a1db734418d0f68a7e50f43095747c08330e952
PYTHON_PYASN1_MODULES_SETUP_TYPE = setuptools
PYTHON_PYASN1_MODULES_LICENSE = BSD-2-Clause
PYTHON_PYASN1_MODULES_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
