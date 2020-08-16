################################################################################
#
# python-pysmi
#
################################################################################

PYTHON_PYSMI_VERSION = 0.3.4
PYTHON_PYSMI_SOURCE = pysmi-$(PYTHON_PYSMI_VERSION).tar.gz
PYTHON_PYSMI_SITE = https://files.pythonhosted.org/packages/52/42/ddaeb06ff551672b17b77f81bc2e26b7c6060b28fe1552226edc6476ce37
PYTHON_PYSMI_SETUP_TYPE = setuptools
PYTHON_PYSMI_LICENSE = BSD-2-Clause
PYTHON_PYSMI_LICENSE_FILES = LICENSE.rst

$(eval $(python-package))
