################################################################################
#
# python-psycopg2
#
################################################################################

PYTHON_PSYCOPG2_VERSION = 2.7.4
PYTHON_PSYCOPG2_SOURCE = psycopg2-$(PYTHON_PSYCOPG2_VERSION).tar.gz
PYTHON_PSYCOPG2_SITE = https://pypi.python.org/packages/74/83/51580322ed0e82cba7ad8e0af590b8fb2cf11bd5aaa1ed872661bd36f462
PYTHON_PSYCOPG2_SETUP_TYPE = setuptools
PYTHON_PSYCOPG2_LICENSE = LGPL-3.0+
PYTHON_PSYCOPG2_LICENSE_FILES = LICENSE
PYTHON_PSYCOPG2_DEPENDENCIES = postgresql

# Force psycopg2 to use the Buildroot provided postgresql version
# instead of the one from the host machine
PYTHON_PSYCOPG2_BUILD_OPTS = build_ext --pg-config=$(STAGING_DIR)/usr/bin/pg_config
PYTHON_PSYCOPG2_INSTALL_TARGET_OPTS = build_ext --pg-config=$(STAGING_DIR)/usr/bin/pg_config

$(eval $(python-package))
