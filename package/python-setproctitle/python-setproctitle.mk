################################################################################
#
# python-setproctitle
#
################################################################################

PYTHON_SETPROCTITLE_VERSION = 1.1.10
PYTHON_SETPROCTITLE_SOURCE = setproctitle-$(PYTHON_SETPROCTITLE_VERSION).tar.gz
PYTHON_SETPROCTITLE_SITE = https://pypi.python.org/packages/5a/0d/dc0d2234aacba6cf1a729964383e3452c52096dc695581248b548786f2b3
PYTHON_SETPROCTITLE_LICENSE = BSD-3-Clause
PYTHON_SETPROCTITLE_LICENSE_FILES = COPYRIGHT
PYTHON_SETPROCTITLE_SETUP_TYPE = distutils

$(eval $(python-package))
