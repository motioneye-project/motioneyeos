################################################################################
#
# python-peewee
#
################################################################################

PYTHON_PEEWEE_VERSION = 3.8.2
PYTHON_PEEWEE_SOURCE = peewee-$(PYTHON_PEEWEE_VERSION).tar.gz
PYTHON_PEEWEE_SITE = https://files.pythonhosted.org/packages/3b/10/619604d488416fb99a2f8ae145ae94f3ebac2812dbd1d334b0785ce7de2e
PYTHON_PEEWEE_SETUP_TYPE = setuptools
PYTHON_PEEWEE_LICENSE = Apache-2.0
PYTHON_PEEWEE_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
