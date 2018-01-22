################################################################################
#
# python-raven
#
################################################################################

PYTHON_RAVEN_VERSION = 6.5.0
PYTHON_RAVEN_SOURCE = raven-$(PYTHON_RAVEN_VERSION).tar.gz
PYTHON_RAVEN_SITE = https://pypi.python.org/packages/e0/26/1bdd4431f59ff92fee7f2378b7d54eb175eb69f68c40c6c9b15161f6774f
PYTHON_RAVEN_SETUP_TYPE = setuptools
PYTHON_RAVEN_LICENSE = BSD-3-Clause
PYTHON_RAVEN_LICENSE_FILES = LICENSE

$(eval $(python-package))
