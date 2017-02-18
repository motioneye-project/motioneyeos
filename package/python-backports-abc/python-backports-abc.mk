################################################################################
#
# python-backports-abc
#
################################################################################

PYTHON_BACKPORTS_ABC_VERSION = 0.4
PYTHON_BACKPORTS_ABC_SOURCE = backports_abc-$(PYTHON_BACKPORTS_ABC_VERSION).tar.gz
PYTHON_BACKPORTS_ABC_SITE = https://pypi.python.org/packages/source/b/backports_abc
PYTHON_BACKPORTS_ABC_LICENSE = Python Software Foundation License
PYTHON_BACKPORTS_ABC_SETUP_TYPE = setuptools

$(eval $(python-package))
