################################################################################
#
# python-ipy
#
################################################################################

PYTHON_IPY_VERSION = IPy-0.82a
PYTHON_IPY_SITE = $(call github,haypo,python-ipy,$(PYTHON_IPY_VERSION))
PYTHON_IPY_LICENSE = BSD-3c
PYTHON_IPY_LICENSE_FILES = COPYING
PYTHON_IPY_SETUP_TYPE = distutils

$(eval $(python-package))
