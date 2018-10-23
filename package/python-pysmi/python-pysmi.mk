################################################################################
#
# python-pysmi
#
################################################################################

PYTHON_PYSMI_VERSION = 0.3.2
PYTHON_PYSMI_SOURCE = pysmi-$(PYTHON_PYSMI_VERSION).tar.gz
PYTHON_PYSMI_SITE = https://files.pythonhosted.org/packages/46/be/8c1b68ec30992dd9f5127fff7bf518110ad4de8ae8533f921ad605d09a01
PYTHON_PYSMI_SETUP_TYPE = setuptools
PYTHON_PYSMI_LICENSE = BSD-2-Clause
PYTHON_PYSMI_LICENSE_FILES = LICENSE.rst

$(eval $(python-package))
