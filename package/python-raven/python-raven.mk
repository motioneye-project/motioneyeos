################################################################################
#
# python-raven
#
################################################################################

PYTHON_RAVEN_VERSION = 6.7.0
PYTHON_RAVEN_SOURCE = raven-$(PYTHON_RAVEN_VERSION).tar.gz
PYTHON_RAVEN_SITE = https://files.pythonhosted.org/packages/d7/54/7d199f893a0ac01f8df9b7ec39c0f3ac19146e78b33401b1f4984c9d3583
PYTHON_RAVEN_SETUP_TYPE = setuptools
PYTHON_RAVEN_LICENSE = BSD-3-Clause
PYTHON_RAVEN_LICENSE_FILES = LICENSE

$(eval $(python-package))
