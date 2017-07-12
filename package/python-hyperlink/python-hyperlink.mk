################################################################################
#
# python-hyperlink
#
################################################################################

PYTHON_HYPERLINK_VERSION = 17.2.1
PYTHON_HYPERLINK_SOURCE = hyperlink-$(PYTHON_HYPERLINK_VERSION).tar.gz
PYTHON_HYPERLINK_SITE = https://pypi.python.org/packages/a2/d9/56b6a007a643d6511e616a2be74f67c3703e2aea4e9eaa44bdf48bc78c82
PYTHON_HYPERLINK_SETUP_TYPE = setuptools
PYTHON_HYPERLINK_LICENSE = MIT

$(eval $(python-package))
