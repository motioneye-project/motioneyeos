################################################################################
#
# python-pyasn1-modules
#
################################################################################

PYTHON_PYASN1_MODULES_VERSION = 0.2.7
PYTHON_PYASN1_MODULES_SOURCE = pyasn1-modules-$(PYTHON_PYASN1_MODULES_VERSION).tar.gz
PYTHON_PYASN1_MODULES_SITE = https://files.pythonhosted.org/packages/75/93/c51104ea6a74252957c341ccd110b65efecc18edfd386b666637d67d4d10
PYTHON_PYASN1_MODULES_SETUP_TYPE = setuptools
PYTHON_PYASN1_MODULES_LICENSE = BSD-2-Clause
PYTHON_PYASN1_MODULES_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
