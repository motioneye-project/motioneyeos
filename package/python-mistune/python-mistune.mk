################################################################################
#
# python-mistune
#
################################################################################

PYTHON_MISTUNE_VERSION = 0.7.3
PYTHON_MISTUNE_SOURCE = mistune-$(PYTHON_MISTUNE_VERSION).tar.gz
PYTHON_MISTUNE_SITE = https://pypi.python.org/packages/88/1e/be99791262b3a794332fda598a07c2749a433b9378586361ba9d8e824607
PYTHON_MISTUNE_LICENSE = BSD-3-Clause
PYTHON_MISTUNE_LICENSE_FILES = LICENSE
PYTHON_MISTUNE_SETUP_TYPE = setuptools

$(eval $(python-package))
$(eval $(host-python-package))
