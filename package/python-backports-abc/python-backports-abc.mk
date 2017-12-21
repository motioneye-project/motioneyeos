################################################################################
#
# python-backports-abc
#
################################################################################

PYTHON_BACKPORTS_ABC_VERSION = 0.5
PYTHON_BACKPORTS_ABC_SOURCE = backports_abc-$(PYTHON_BACKPORTS_ABC_VERSION).tar.gz
PYTHON_BACKPORTS_ABC_SITE = https://pypi.python.org/packages/68/3c/1317a9113c377d1e33711ca8de1e80afbaf4a3c950dd0edfaf61f9bfe6d8
PYTHON_BACKPORTS_ABC_LICENSE = Python-2.0
PYTHON_BACKPORTS_ABC_LICENSE_FILES = LICENSE
PYTHON_BACKPORTS_ABC_SETUP_TYPE = setuptools

$(eval $(python-package))
