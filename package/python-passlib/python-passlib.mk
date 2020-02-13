################################################################################
#
# python-passlib
#
################################################################################

PYTHON_PASSLIB_VERSION = 1.7.2
PYTHON_PASSLIB_SOURCE = passlib-$(PYTHON_PASSLIB_VERSION).tar.gz
PYTHON_PASSLIB_SITE = https://files.pythonhosted.org/packages/6d/6b/4bfca0c13506535289b58f9c9761d20f56ed89439bfe6b8e07416ce58ee1
PYTHON_PASSLIB_SETUP_TYPE = setuptools
PYTHON_PASSLIB_LICENSE = BSD-3-Clause
PYTHON_PASSLIB_LICENSE_FILES = LICENSE

$(eval $(python-package))
