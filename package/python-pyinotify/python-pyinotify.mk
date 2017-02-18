################################################################################
#
# python-pyinotify
#
################################################################################

PYTHON_PYINOTIFY_VERSION = 0.9.6
PYTHON_PYINOTIFY_SITE = $(call github,seb-m,pyinotify,$(PYTHON_PYINOTIFY_VERSION))
PYTHON_PYINOTIFY_SETUP_TYPE = setuptools
PYTHON_PYINOTIFY_LICENSE = MIT
PYTHON_PYINOTIFY_LICENSE_FILES = COPYING

$(eval $(python-package))
