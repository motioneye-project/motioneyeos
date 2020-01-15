################################################################################
#
# python-aenum
#
################################################################################

PYTHON_AENUM_VERSION = 2.2.3
PYTHON_AENUM_SOURCE = aenum-$(PYTHON_AENUM_VERSION).tar.gz
PYTHON_AENUM_SITE = https://files.pythonhosted.org/packages/6f/6a/8ed729e0add885d7a559ebb06133029b1f8c4bd66cbf1bdee1ec969fb310
PYTHON_AENUM_SETUP_TYPE = setuptools
PYTHON_AENUM_LICENSE = BSD-3-Clause
PYTHON_AENUM_LICENSE_FILES = aenum/LICENSE

$(eval $(python-package))
