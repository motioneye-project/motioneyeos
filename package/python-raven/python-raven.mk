################################################################################
#
# python-raven
#
################################################################################

PYTHON_RAVEN_VERSION = 6.10.0
PYTHON_RAVEN_SOURCE = raven-$(PYTHON_RAVEN_VERSION).tar.gz
PYTHON_RAVEN_SITE = https://files.pythonhosted.org/packages/79/57/b74a86d74f96b224a477316d418389af9738ba7a63c829477e7a86dd6f47
PYTHON_RAVEN_SETUP_TYPE = setuptools
PYTHON_RAVEN_LICENSE = BSD-3-Clause
PYTHON_RAVEN_LICENSE_FILES = LICENSE

$(eval $(python-package))
