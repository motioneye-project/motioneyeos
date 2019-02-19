################################################################################
#
# python-xlib
#
################################################################################

PYTHON_XLIB_VERSION = 0.25
PYTHON_XLIB_SOURCE = python-xlib-$(PYTHON_XLIB_VERSION).tar.bz2
PYTHON_XLIB_SITE = https://files.pythonhosted.org/packages/3c/d9/51fc07ae57f6a44e62e2ee04bd501d763ac169ff05c838403ec7ae556992
PYTHON_XLIB_SETUP_TYPE = setuptools
PYTHON_XLIB_LICENSE = LGPL-2.1+
PYTHON_XLIB_LICENSE_FILES = LICENSE
PYTHON_XLIB_DEPENDENCIES = host-python-setuptools-scm

$(eval $(python-package))
