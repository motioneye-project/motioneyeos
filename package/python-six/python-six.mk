################################################################################
#
# python-six
#
################################################################################

PYTHON_SIX_VERSION = 1.11.0
PYTHON_SIX_SOURCE = six-$(PYTHON_SIX_VERSION).tar.gz
PYTHON_SIX_SITE = https://pypi.python.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe
PYTHON_SIX_SETUP_TYPE = setuptools
PYTHON_SIX_LICENSE = MIT
PYTHON_SIX_LICENSE_FILES = LICENSE

$(eval $(python-package))
$(eval $(host-python-package))
