################################################################################
#
# python-pbr
#
################################################################################

PYTHON_PBR_VERSION = 5.2.0
PYTHON_PBR_SOURCE = pbr-$(PYTHON_PBR_VERSION).tar.gz
PYTHON_PBR_SITE = https://files.pythonhosted.org/packages/11/3d/3b5bbf398535d78a8cd7cf01441a745dedda5ca69f82658f2c7672bcdcce
PYTHON_PBR_SETUP_TYPE = setuptools
PYTHON_PBR_LICENSE = Apache-2.0
PYTHON_PBR_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
$(eval $(host-python-package))
