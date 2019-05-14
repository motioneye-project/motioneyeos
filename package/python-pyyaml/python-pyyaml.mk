################################################################################
#
# python-pyyaml
#
################################################################################

PYTHON_PYYAML_VERSION = 4.2b4
PYTHON_PYYAML_SOURCE = PyYAML-$(PYTHON_PYYAML_VERSION).tar.gz
PYTHON_PYYAML_SITE = https://files.pythonhosted.org/packages/a8/c6/a8d1555e795dbd0375c3c93b576ca13bbf139db51ea604afa19a2c35fc03
PYTHON_PYYAML_SETUP_TYPE = distutils
PYTHON_PYYAML_LICENSE = MIT
PYTHON_PYYAML_LICENSE_FILES = LICENSE
PYTHON_PYYAML_DEPENDENCIES = libyaml
HOST_PYTHON_PYYAML_DEPENDENCIES = host-libyaml

$(eval $(python-package))
$(eval $(host-python-package))
