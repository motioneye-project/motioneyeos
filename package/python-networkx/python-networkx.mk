################################################################################
#
# python-networkx
#
################################################################################

# The current version of setools (v4.1.1) does not work with python-networkx past v1.11
PYTHON_NETWORKX_VERSION = 1.11
PYTHON_NETWORKX_SOURCE = networkx-$(PYTHON_NETWORKX_VERSION).tar.gz
PYTHON_NETWORKX_SITE = https://pypi.python.org/packages/c2/93/dbb41b03cf7c878a7409c8e92226531f840a423c9309ea534873a83c9192
PYTHON_NETWORKX_LICENSE = BSD-3-Clause
PYTHON_NETWORKX_LICENSE_FILES = LICENSE.txt
PYTHON_NETWORKX_SETUP_TYPE = setuptools
HOST_PYTHON_NETWORKX_DEPENDENCIES = host-python-decorator

$(eval $(python-package))
$(eval $(host-python-package))
