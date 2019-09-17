################################################################################
#
# python-kiwisolver
#
################################################################################

PYTHON_KIWISOLVER_VERSION = 1.1.0
PYTHON_KIWISOLVER_SITE = $(call github,nucleic,kiwi,$(PYTHON_KIWISOLVER_VERSION))
PYTHON_KIWISOLVER_LICENSE = BSD-3-Clause
PYTHON_KIWISOLVER_LICENSE_FILES = LICENSE
PYTHON_KIWISOLVER_SETUP_TYPE = setuptools

$(eval $(python-package))
