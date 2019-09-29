################################################################################
#
# python-peewee
#
################################################################################

PYTHON_PEEWEE_VERSION = 3.9.5
PYTHON_PEEWEE_SOURCE = peewee-$(PYTHON_PEEWEE_VERSION).tar.gz
PYTHON_PEEWEE_SITE = https://files.pythonhosted.org/packages/ec/72/784eaf8c15d1dd0d5c126b2180bf3dd860611f7ba2b746c8e9cacee9a172
PYTHON_PEEWEE_SETUP_TYPE = setuptools
PYTHON_PEEWEE_LICENSE = Apache-2.0
PYTHON_PEEWEE_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
