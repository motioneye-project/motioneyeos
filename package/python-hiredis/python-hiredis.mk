################################################################################
#
# python-hiredis
#
################################################################################

PYTHON_HIREDIS_VERSION = 1.0.1
PYTHON_HIREDIS_SOURCE = hiredis-$(PYTHON_HIREDIS_VERSION).tar.gz
PYTHON_HIREDIS_SITE = https://files.pythonhosted.org/packages/7f/5c/62e5c6b811b4dcef4125b4a01f76db82c496d79299dd67053b8f9c0732c0
PYTHON_HIREDIS_SETUP_TYPE = setuptools
PYTHON_HIREDIS_LICENSE = BSD-3-Clause
PYTHON_HIREDIS_LICENSE_FILES = COPYING vendor/hiredis/COPYING

$(eval $(python-package))
