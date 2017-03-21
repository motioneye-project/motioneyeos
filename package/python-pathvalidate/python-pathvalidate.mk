################################################################################
#
# python-pathvalidate
#
################################################################################

PYTHON_PATHVALIDATE_VERSION = 0.15.0
PYTHON_PATHVALIDATE_SOURCE = pathvalidate-$(PYTHON_PATHVALIDATE_VERSION).tar.gz
PYTHON_PATHVALIDATE_SITE = https://pypi.python.org/packages/a6/7b/2c3026ead121829ed27eba4fba7b4cd6ec8c210f76b0601119a915918f6c
PYTHON_PATHVALIDATE_SETUP_TYPE = setuptools
PYTHON_PATHVALIDATE_LICENSE = MIT
PYTHON_PATHVALIDATE_LICENSE_FILES = LICENSE

$(eval $(python-package))
