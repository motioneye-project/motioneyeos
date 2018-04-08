################################################################################
#
# python-yieldfrom
#
################################################################################

PYTHON_YIELDFROM_VERSION = 1.0.3
PYTHON_YIELDFROM_SOURCE = yieldfrom-$(PYTHON_YIELDFROM_VERSION).tar.gz
PYTHON_YIELDFROM_SITE = https://pypi.python.org/packages/de/2d/05524f368e691846824d962b64f983e3fde9b8c10839e7efbc1b51d42de3
PYTHON_YIELDFROM_SETUP_TYPE = setuptools
PYTHON_YIELDFROM_LICENSE = MIT
PYTHON_YIELDFROM_LICENSE_FILES = PKG-INFO

$(eval $(python-package))
$(eval $(host-python-package))
