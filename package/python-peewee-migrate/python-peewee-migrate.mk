################################################################################
#
# python-peewee-migrate
#
################################################################################

PYTHON_PEEWEE_MIGRATE_VERSION = 1.1.4
PYTHON_PEEWEE_MIGRATE_SOURCE = peewee_migrate-$(PYTHON_PEEWEE_MIGRATE_VERSION).tar.gz
PYTHON_PEEWEE_MIGRATE_SITE = https://files.pythonhosted.org/packages/64/d1/9a08e399631831e9230b702e79da67577228328f8abd0402ea7c72b9d6b8
PYTHON_PEEWEE_MIGRATE_SETUP_TYPE = setuptools
PYTHON_PEEWEE_MIGRATE_LICENSE = Apache-2.0
PYTHON_PEEWEE_MIGRATE_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
