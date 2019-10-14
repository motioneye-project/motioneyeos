################################################################################
#
# python-meld3
#
################################################################################

PYTHON_MELD3_VERSION = 2.0.0
PYTHON_MELD3_SOURCE = meld3-$(PYTHON_MELD3_VERSION).tar.gz
PYTHON_MELD3_SITE = https://files.pythonhosted.org/packages/00/3b/023446ddc1bf0b519c369cbe88269c30c6a64bd10af4817c73f560c302f7
PYTHON_MELD3_LICENSE = ZPL-2.1
PYTHON_MELD3_LICENSE_FILES = COPYRIGHT.txt LICENSE.txt
PYTHON_MELD3_SETUP_TYPE = setuptools

$(eval $(python-package))
