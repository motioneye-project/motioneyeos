################################################################################
#
# python-json-schema-validator
#
################################################################################

PYTHON_JSON_SCHEMA_VALIDATOR_VERSION = 2.4.1
PYTHON_JSON_SCHEMA_VALIDATOR_SOURCE = json-schema-validator-$(PYTHON_JSON_SCHEMA_VALIDATOR_VERSION).tar.gz
PYTHON_JSON_SCHEMA_VALIDATOR_SITE = https://pypi.python.org/packages/70/46/ba39cb7efad1898cfc89bf3588b8612f24d128f1c25b761994f524a59cef
PYTHON_JSON_SCHEMA_VALIDATOR_LICENSE = LGPLv3
PYTHON_JSON_SCHEMA_VALIDATOR_SETUP_TYPE = setuptools
PYTHON_JSON_SCHEMA_VALIDATOR_DEPENDENCIES = python-versiontools

$(eval $(python-package))
