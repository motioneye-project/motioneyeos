################################################################################
#
# python-multidict
#
################################################################################

PYTHON_MULTIDICT_VERSION = 4.7.3
PYTHON_MULTIDICT_SOURCE = multidict-$(PYTHON_MULTIDICT_VERSION).tar.gz
PYTHON_MULTIDICT_SITE = https://files.pythonhosted.org/packages/84/96/5503ba866d8d216e49a6ce3bcb288df8a5fb3ac8a90b8fcff9ddcda32568
PYTHON_MULTIDICT_SETUP_TYPE = setuptools
PYTHON_MULTIDICT_LICENSE = Apache-2.0
PYTHON_MULTIDICT_LICENSE_FILES = LICENSE

$(eval $(python-package))
