################################################################################
#
# python-json-schema-validator
#
################################################################################

PYTHON_JSON_SCHEMA_VALIDATOR_VERSION = 2.3
PYTHON_JSON_SCHEMA_VALIDATOR_SOURCE = json-schema-validator-$(PYTHON_JSON_SCHEMA_VALIDATOR_VERSION).tar.gz
PYTHON_JSON_SCHEMA_VALIDATOR_SITE = http://pypi.python.org/packages/source/j/json-schema-validator/
PYTHON_JSON_SCHEMA_VALIDATOR_LICENSE = LGPLv3
PYTHON_JSON_SCHEMA_VALIDATOR_SETUP_TYPE = setuptools
PYTHON_JSON_SCHEMA_VALIDATOR_DEPENDENCIES = python-versiontools

$(eval $(python-package))
