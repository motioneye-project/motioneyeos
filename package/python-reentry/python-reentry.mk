################################################################################
#
# python-reentry
#
################################################################################

PYTHON_REENTRY_VERSION = 1.3.1
PYTHON_REENTRY_SOURCE = reentry-$(PYTHON_REENTRY_VERSION).tar.gz
PYTHON_REENTRY_SITE = https://files.pythonhosted.org/packages/ee/3f/a90789e01c4d2b67a57e9bd758e60ecb9338d428604f66130b57684ba8cc
PYTHON_REENTRY_SETUP_TYPE = setuptools
PYTHON_REENTRY_LICENSE = MIT
PYTHON_REENTRY_LICENSE_FILES = LICENSE

$(eval $(python-package))
