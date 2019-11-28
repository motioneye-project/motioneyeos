################################################################################
#
# python-multidict
#
################################################################################

PYTHON_MULTIDICT_VERSION = 4.6.1
PYTHON_MULTIDICT_SOURCE = multidict-$(PYTHON_MULTIDICT_VERSION).tar.gz
PYTHON_MULTIDICT_SITE = https://files.pythonhosted.org/packages/8a/74/61547af55c077b8d2e3648c2af74c08fa1e382665b290468db7ba54db2ea
PYTHON_MULTIDICT_SETUP_TYPE = setuptools
PYTHON_MULTIDICT_LICENSE = Apache-2.0
PYTHON_MULTIDICT_LICENSE_FILES = LICENSE

$(eval $(python-package))
