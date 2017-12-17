################################################################################
#
# python-sdnotify
#
################################################################################

PYTHON_SDNOTIFY_VERSION = 0.3.1
PYTHON_SDNOTIFY_SOURCE = sdnotify-$(PYTHON_SDNOTIFY_VERSION).tar.gz
PYTHON_SDNOTIFY_SITE = https://pypi.python.org/packages/57/f9/ae03e3ebc83be0d501cde1f5d6d23dee74f5c2105f2cdb98bff4fa9ada9c
PYTHON_SDNOTIFY_SETUP_TYPE = distutils
PYTHON_SDNOTIFY_LICENSE = MIT
PYTHON_SDNOTIFY_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
