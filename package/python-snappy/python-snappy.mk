################################################################################
#
# python-snappy
#
################################################################################

PYTHON_SNAPPY_VERSION = 0.5.4
PYTHON_SNAPPY_SITE = https://files.pythonhosted.org/packages/45/35/65d9f8cc537129894b4b32647d80212d1fa342877581c5b8a69872cea8be
PYTHON_SNAPPY_SETUP_TYPE = setuptools
PYTHON_SNAPPY_LICENSE = BSD-3-Clause
PYTHON_SNAPPY_LICENSE_FILES = LICENSE
PYTHON_SNAPPY_DEPENDENCIES = snappy

$(eval $(python-package))
