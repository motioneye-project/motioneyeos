################################################################################
#
# python-pysmi
#
################################################################################

PYTHON_PYSMI_VERSION = 0.3.3
PYTHON_PYSMI_SOURCE = pysmi-$(PYTHON_PYSMI_VERSION).tar.gz
PYTHON_PYSMI_SITE = https://files.pythonhosted.org/packages/71/32/182dd4fa0c4e20c2a14154d3133cc08374694c2518a7c5445a918332b113
PYTHON_PYSMI_SETUP_TYPE = setuptools
PYTHON_PYSMI_LICENSE = BSD-2-Clause
PYTHON_PYSMI_LICENSE_FILES = LICENSE.rst

$(eval $(python-package))
