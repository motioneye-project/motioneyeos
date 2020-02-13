################################################################################
#
# python-pyyaml
#
################################################################################

PYTHON_PYYAML_VERSION = 5.3
PYTHON_PYYAML_SOURCE = PyYAML-$(PYTHON_PYYAML_VERSION).tar.gz
PYTHON_PYYAML_SITE = https://files.pythonhosted.org/packages/3d/d9/ea9816aea31beeadccd03f1f8b625ecf8f645bd66744484d162d84803ce5
PYTHON_PYYAML_SETUP_TYPE = distutils
PYTHON_PYYAML_LICENSE = MIT
PYTHON_PYYAML_LICENSE_FILES = LICENSE
PYTHON_PYYAML_DEPENDENCIES = libyaml
HOST_PYTHON_PYYAML_DEPENDENCIES = host-libyaml

$(eval $(python-package))
$(eval $(host-python-package))
