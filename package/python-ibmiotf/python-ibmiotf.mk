################################################################################
#
# python-ibmiotf
#
################################################################################

PYTHON_IBMIOTF_VERSION = 0.4.0
PYTHON_IBMIOTF_SOURCE = ibmiotf-$(PYTHON_IBMIOTF_VERSION).tar.gz
PYTHON_IBMIOTF_SITE = https://files.pythonhosted.org/packages/78/05/029ca6f78b788a3c55157fd11bb63922d002d75df982ffb8243f450a750e
PYTHON_IBMIOTF_SETUP_TYPE = setuptools
PYTHON_IBMIOTF_LICENSE = EPL-1.0
PYTHON_IBMIOTF_LICENSE_FILES = LICENSE

$(eval $(python-package))
