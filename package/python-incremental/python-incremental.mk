################################################################################
#
# python-incremental
#
################################################################################

PYTHON_INCREMENTAL_VERSION = 16.10.1
PYTHON_INCREMENTAL_SOURCE = incremental-$(PYTHON_INCREMENTAL_VERSION).tar.gz
PYTHON_INCREMENTAL_SITE = https://pypi.python.org/packages/da/b0/32233c9e84b0d44b39015fba8fec03e88053723c1b455925081dc6ccd9e7
PYTHON_INCREMENTAL_SETUP_TYPE = setuptools
PYTHON_INCREMENTAL_LICENSE = MIT
PYTHON_INCREMENTAL_LICENSE_FILES = LICENSE

$(eval $(python-package))
$(eval $(host-python-package))
