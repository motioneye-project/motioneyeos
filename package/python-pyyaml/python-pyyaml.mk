################################################################################
#
# python-pyyaml
#
################################################################################

PYTHON_PYYAML_VERSION = 5.1.2
PYTHON_PYYAML_SOURCE = PyYAML-$(PYTHON_PYYAML_VERSION).tar.gz
PYTHON_PYYAML_SITE = https://files.pythonhosted.org/packages/e3/e8/b3212641ee2718d556df0f23f78de8303f068fe29cdaa7a91018849582fe
PYTHON_PYYAML_SETUP_TYPE = distutils
PYTHON_PYYAML_LICENSE = MIT
PYTHON_PYYAML_LICENSE_FILES = LICENSE
PYTHON_PYYAML_DEPENDENCIES = libyaml
HOST_PYTHON_PYYAML_DEPENDENCIES = host-libyaml

$(eval $(python-package))
$(eval $(host-python-package))
