################################################################################
#
# python-hyperlink
#
################################################################################

PYTHON_HYPERLINK_VERSION = 19.0.0
PYTHON_HYPERLINK_SOURCE = hyperlink-$(PYTHON_HYPERLINK_VERSION).tar.gz
PYTHON_HYPERLINK_SITE = https://files.pythonhosted.org/packages/e0/46/1451027b513a75edf676d25a47f601ca00b06a6a7a109e5644d921e7462d
PYTHON_HYPERLINK_SETUP_TYPE = setuptools
PYTHON_HYPERLINK_LICENSE = MIT
PYTHON_HYPERLINK_LICENSE_FILES = LICENSE

$(eval $(python-package))
