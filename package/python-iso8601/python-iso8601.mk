################################################################################
#
# python-iso8601
#
################################################################################

PYTHON_ISO8601_VERSION = 0.1.12
PYTHON_ISO8601_SOURCE = iso8601-$(PYTHON_ISO8601_VERSION).tar.gz
PYTHON_ISO8601_SITE = https://pypi.python.org/packages/45/13/3db24895497345fb44c4248c08b16da34a9eb02643cea2754b21b5ed08b0
PYTHON_ISO8601_SETUP_TYPE = setuptools
PYTHON_ISO8601_LICENSE = MIT
PYTHON_ISO8601_LICENSE_FILES = LICENSE

$(eval $(python-package))
