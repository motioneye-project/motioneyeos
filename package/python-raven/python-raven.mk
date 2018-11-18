################################################################################
#
# python-raven
#
################################################################################

PYTHON_RAVEN_VERSION = 6.9.0
PYTHON_RAVEN_SOURCE = raven-$(PYTHON_RAVEN_VERSION).tar.gz
PYTHON_RAVEN_SITE = https://files.pythonhosted.org/packages/8f/80/e8d734244fd377fd7d65275b27252642512ccabe7850105922116340a37b
PYTHON_RAVEN_SETUP_TYPE = setuptools
PYTHON_RAVEN_LICENSE = BSD-3-Clause
PYTHON_RAVEN_LICENSE_FILES = LICENSE

$(eval $(python-package))
