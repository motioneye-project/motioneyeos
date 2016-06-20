################################################################################
#
# python-pathvalidate
#
################################################################################

PYTHON_PATHVALIDATE_VERSION = 0.4.2
PYTHON_PATHVALIDATE_SOURCE = pathvalidate-$(PYTHON_PATHVALIDATE_VERSION).tar.gz
PYTHON_PATHVALIDATE_SITE = https://pypi.python.org/packages/fd/b9/726269557d5846f253f7ecec483d801582a27b77852a76e2dc9c61dba2b6
PYTHON_PATHVALIDATE_SETUP_TYPE = setuptools
PYTHON_PATHVALIDATE_LICENSE = MIT
PYTHON_PATHVALIDATE_LICENSE_FILES = LICENSE

$(eval $(python-package))
