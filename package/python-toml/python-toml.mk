################################################################################
#
# python-toml
#
################################################################################

PYTHON_TOML_VERSION = 0.9.3
PYTHON_TOML_SITE = $(call github,uiri,toml,$(PYTHON_TOML_VERSION))
PYTHON_TOML_SETUP_TYPE = setuptools
PYTHON_TOML_LICENSE = MIT
PYTHON_TOML_LICENSE_FILES = LICENSE

$(eval $(python-package))
