################################################################################
#
# python-sortedcontainers
#
################################################################################

PYTHON_SORTEDCONTAINERS_VERSION = 2.1.0
PYTHON_SORTEDCONTAINERS_SOURCE = sortedcontainers-$(PYTHON_SORTEDCONTAINERS_VERSION).tar.gz
PYTHON_SORTEDCONTAINERS_SITE = https://files.pythonhosted.org/packages/29/e0/135df2e733790a3d3bcda970fd080617be8cea3bd98f411e76e6847c17ef
PYTHON_SORTEDCONTAINERS_SETUP_TYPE = setuptools
PYTHON_SORTEDCONTAINERS_LICENSE = Apache-2.0
PYTHON_SORTEDCONTAINERS_LICENSE_FILES = LICENSE

$(eval $(python-package))
