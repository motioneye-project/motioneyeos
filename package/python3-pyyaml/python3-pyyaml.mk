################################################################################
#
# python3-pyyaml
#
################################################################################

# Please keep in sync with package/python-pyyaml/python-pyyaml.mk
PYTHON3_PYYAML_VERSION = 5.3.1
PYTHON3_PYYAML_SOURCE = PyYAML-$(PYTHON3_PYYAML_VERSION).tar.gz
PYTHON3_PYYAML_SITE = https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c
PYTHON3_PYYAML_SETUP_TYPE = distutils
PYTHON3_PYYAML_LICENSE = MIT
PYTHON3_PYYAML_LICENSE_FILES = LICENSE
HOST_PYTHON3_PYYAML_DL_SUBDIR = python-pyyaml
HOST_PYTHON3_PYYAML_NEEDS_HOST_PYTHON = python3
HOST_PYTHON3_PYYAML_DEPENDENCIES = host-libyaml

$(eval $(host-python-package))
