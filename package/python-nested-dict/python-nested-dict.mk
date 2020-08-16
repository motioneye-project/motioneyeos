################################################################################
#
# python-nested-dict
#
################################################################################

PYTHON_NESTED_DICT_VERSION = 1.61
PYTHON_NESTED_DICT_SOURCE = nested_dict-$(PYTHON_NESTED_DICT_VERSION).tar.gz
PYTHON_NESTED_DICT_SITE = https://files.pythonhosted.org/packages/42/d0/3b27fa65b16a2e44d793af59929fcdb3bb84b4664462ff2830105dfd9b7d
PYTHON_NESTED_DICT_SETUP_TYPE = setuptools
PYTHON_NESTED_DICT_LICENSE = MIT
PYTHON_NESTED_DICT_LICENSE_FILES = LICENSE.TXT

$(eval $(python-package))
