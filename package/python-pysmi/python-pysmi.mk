################################################################################
#
# python-pysmi
#
################################################################################

PYTHON_PYSMI_VERSION = 0.3.1
PYTHON_PYSMI_SOURCE = pysmi-$(PYTHON_PYSMI_VERSION).tar.gz
PYTHON_PYSMI_SITE = https://files.pythonhosted.org/packages/8f/14/68331f94a5cd94e00ff064c9a790e6d7b0a0ade8c66deafa543398ca72ee
PYTHON_PYSMI_SETUP_TYPE = setuptools
PYTHON_PYSMI_LICENSE = BSD-2-Clause
PYTHON_PYSMI_LICENSE_FILES = LICENSE.rst

$(eval $(python-package))
