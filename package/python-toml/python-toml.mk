################################################################################
#
# python-toml
#
################################################################################

PYTHON_TOML_VERSION = 0.10.0
PYTHON_TOML_SOURCE = toml-$(PYTHON_TOML_VERSION).tar.gz
PYTHON_TOML_SITE = https://files.pythonhosted.org/packages/b9/19/5cbd78eac8b1783671c40e34bb0fa83133a06d340a38b55c645076d40094
PYTHON_TOML_SETUP_TYPE = setuptools
PYTHON_TOML_LICENSE = MIT
PYTHON_TOML_LICENSE_FILES = LICENSE

$(eval $(python-package))
