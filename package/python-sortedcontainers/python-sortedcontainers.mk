################################################################################
#
# python-sortedcontainers
#
################################################################################

PYTHON_SORTEDCONTAINERS_VERSION = 2.0.5
PYTHON_SORTEDCONTAINERS_SOURCE = sortedcontainers-$(PYTHON_SORTEDCONTAINERS_VERSION).tar.gz
PYTHON_SORTEDCONTAINERS_SITE = https://files.pythonhosted.org/packages/b9/30/accbf5c09c5fa25a3d5f762761e0d7ece6fdb12f2a9c43b840f73cef43ef
PYTHON_SORTEDCONTAINERS_SETUP_TYPE = setuptools
PYTHON_SORTEDCONTAINERS_LICENSE = Apache-2.0
PYTHON_SORTEDCONTAINERS_LICENSE_FILES = LICENSE

$(eval $(python-package))
