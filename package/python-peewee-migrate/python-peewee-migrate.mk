################################################################################
#
# python-peewee-migrate
#
################################################################################

PYTHON_PEEWEE_MIGRATE_VERSION = 1.1.6
PYTHON_PEEWEE_MIGRATE_SOURCE = peewee_migrate-$(PYTHON_PEEWEE_MIGRATE_VERSION).tar.gz
PYTHON_PEEWEE_MIGRATE_SITE = https://files.pythonhosted.org/packages/d2/ed/24d221811e9f735719795a08da1e8bcc9f133b46a02d7862b521733320b6
PYTHON_PEEWEE_MIGRATE_SETUP_TYPE = setuptools
PYTHON_PEEWEE_MIGRATE_LICENSE = Apache-2.0
PYTHON_PEEWEE_MIGRATE_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
