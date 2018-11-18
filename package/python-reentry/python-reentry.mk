################################################################################
#
# python-reentry
#
################################################################################

PYTHON_REENTRY_VERSION = 1.2.0
PYTHON_REENTRY_SOURCE = reentry-$(PYTHON_REENTRY_VERSION).tar.gz
PYTHON_REENTRY_SITE = https://files.pythonhosted.org/packages/e2/b4/46dfac6613302fea51454a01aebedae9440aff9d813aedbbc5f687552e3b
PYTHON_REENTRY_SETUP_TYPE = setuptools
PYTHON_REENTRY_LICENSE = MIT
PYTHON_REENTRY_LICENSE_FILES = LICENSE

$(eval $(python-package))
