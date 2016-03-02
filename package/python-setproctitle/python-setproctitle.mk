################################################################################
#
# python-setproctitle
#
################################################################################

PYTHON_SETPROCTITLE_VERSION = 1.1.9
PYTHON_SETPROCTITLE_SOURCE = setproctitle-$(PYTHON_SETPROCTITLE_VERSION).tar.gz
PYTHON_SETPROCTITLE_SITE = http://pypi.python.org/packages/source/s/setproctitle
PYTHON_SETPROCTITLE_LICENSE = BSD-3c
PYTHON_SETPROCTITLE_LICENSE_FILES = COPYRIGHT
PYTHON_SETPROCTITLE_SETUP_TYPE = distutils

$(eval $(python-package))
