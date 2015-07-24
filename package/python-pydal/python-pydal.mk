################################################################################
#
# python-pydal
#
################################################################################

PYTHON_PYDAL_VERSION = v15.07
PYTHON_PYDAL_SITE = $(call github,web2py,pydal,$(PYTHON_PYDAL_VERSION))
PYTHON_PYDAL_LICENSE = BSD-3c
PYTHON_PYDAL_LICENSE_FILES = LICENSE
PYTHON_PYDAL_SETUP_TYPE = setuptools

$(eval $(python-package))
$(eval $(host-python-package))
