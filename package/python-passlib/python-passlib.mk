################################################################################
#
# python-passlib
#
################################################################################

PYTHON_PASSLIB_VERSION = 1.7.1
PYTHON_PASSLIB_SOURCE = passlib-$(PYTHON_PASSLIB_VERSION).tar.gz
PYTHON_PASSLIB_SITE = https://files.pythonhosted.org/packages/25/4b/6fbfc66aabb3017cd8c3bd97b37f769d7503ead2899bf76e570eb91270de
PYTHON_PASSLIB_SETUP_TYPE = setuptools
PYTHON_PASSLIB_LICENSE = BSD-3-Clause
PYTHON_PASSLIB_LICENSE_FILES = LICENSE

$(eval $(python-package))
