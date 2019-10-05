################################################################################
#
# python-setupnovernormalize
#
################################################################################

PYTHON_SETUPNOVERNORMALIZE_VERSION = 1.0.1
PYTHON_SETUPNOVERNORMALIZE_SOURCE = setupnovernormalize-$(PYTHON_SETUPNOVERNORMALIZE_VERSION).tar.gz
PYTHON_SETUPNOVERNORMALIZE_SITE = https://files.pythonhosted.org/packages/1d/52/fa80eef76aa8e1672f113a63326a4d12f5a1dc7a75798a2e08dc2dea3a8c
PYTHON_SETUPNOVERNORMALIZE_SETUP_TYPE = setuptools
PYTHON_SETUPNOVERNORMALIZE_LICENSE = UNLICENSE

$(eval $(python-package))
