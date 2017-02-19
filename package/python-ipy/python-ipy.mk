################################################################################
#
# python-ipy
#
################################################################################

PYTHON_IPY_VERSION = 0.83
PYTHON_IPY_SOURCE = IPy-$(PYTHON_IPY_VERSION).tar.gz
PYTHON_IPY_SITE = https://pypi.python.org/packages/88/28/79162bfc351a3f1ab44d663ab3f03fb495806fdb592170990a1568ffbf63
PYTHON_IPY_LICENSE = BSD-3c
PYTHON_IPY_LICENSE_FILES = COPYING
PYTHON_IPY_SETUP_TYPE = distutils

$(eval $(python-package))
