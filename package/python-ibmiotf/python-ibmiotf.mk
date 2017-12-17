################################################################################
#
# python-ibmiotf
#
################################################################################

PYTHON_IBMIOTF_VERSION = 0.2.8
PYTHON_IBMIOTF_SITE = $(call github,ibm-watson-iot,iot-python,$(PYTHON_IBMIOTF_VERSION))
PYTHON_IBMIOTF_SETUP_TYPE = setuptools
PYTHON_IBMIOTF_LICENSE = EPL-1.0
PYTHON_IBMIOTF_LICENSE_FILES = LICENSE

$(eval $(python-package))
