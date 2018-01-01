################################################################################
#
# python-mistune
#
################################################################################

PYTHON_MISTUNE_VERSION = 0.8
PYTHON_MISTUNE_SOURCE = mistune-$(PYTHON_MISTUNE_VERSION).tar.gz
PYTHON_MISTUNE_SITE = https://pypi.python.org/packages/d3/66/a45d1c7c50fd63a707cd1bd340b969523137c5284d9466c41012fe54c621
PYTHON_MISTUNE_LICENSE = BSD-3-Clause
PYTHON_MISTUNE_LICENSE_FILES = LICENSE
PYTHON_MISTUNE_SETUP_TYPE = setuptools

$(eval $(python-package))
$(eval $(host-python-package))
