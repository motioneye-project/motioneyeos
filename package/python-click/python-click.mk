################################################################################
#
# python-click
#
################################################################################

PYTHON_CLICK_VERSION = 7.0
PYTHON_CLICK_SOURCE = Click-$(PYTHON_CLICK_VERSION).tar.gz
PYTHON_CLICK_SITE = https://files.pythonhosted.org/packages/f8/5c/f60e9d8a1e77005f664b76ff8aeaee5bc05d0a91798afd7f53fc998dbc47
PYTHON_CLICK_LICENSE = BSD-3-Clause
PYTHON_CLICK_LICENSE_FILES = LICENSE.rst
PYTHON_CLICK_SETUP_TYPE = setuptools

$(eval $(python-package))
