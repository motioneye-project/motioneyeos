################################################################################
#
# python-xlib
#
################################################################################

PYTHON_XLIB_VERSION = 0.21
PYTHON_XLIB_SOURCE = python-xlib-$(PYTHON_XLIB_VERSION).tar.bz2
PYTHON_XLIB_SITE = https://pypi.python.org/packages/eb/de/b0eaaea7b8512dc41504db071824eef30293ff55c58d83081ebaebe85a38
PYTHON_XLIB_SETUP_TYPE = setuptools
PYTHON_XLIB_LICENSE = LGPL-2.1+
PYTHON_XLIB_LICENSE_FILES = LICENSE
PYTHON_XLIB_DEPENDENCIES = host-python-setuptools-scm

$(eval $(python-package))
