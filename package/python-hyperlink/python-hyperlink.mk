################################################################################
#
# python-hyperlink
#
################################################################################

PYTHON_HYPERLINK_VERSION = 17.3.0
PYTHON_HYPERLINK_SOURCE = hyperlink-$(PYTHON_HYPERLINK_VERSION).tar.gz
PYTHON_HYPERLINK_SITE = https://pypi.python.org/packages/61/9c/69aa5d6942271961ad1fff910db77706623423d054ecb647da963efdf49a
PYTHON_HYPERLINK_SETUP_TYPE = setuptools
PYTHON_HYPERLINK_LICENSE = MIT
PYTHON_HYPERLINK_LICENSE_FILES = LICENSE

$(eval $(python-package))
