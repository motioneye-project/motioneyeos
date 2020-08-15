################################################################################
#
# python-falcon
#
################################################################################

PYTHON_FALCON_VERSION = 2.0.0
PYTHON_FALCON_SOURCE = falcon-$(PYTHON_FALCON_VERSION).tar.gz
PYTHON_FALCON_SITE = https://files.pythonhosted.org/packages/19/30/edff5a1fea7a8e9876c8391e170263e1bb207875b6a65cd619818487b27b
PYTHON_FALCON_SETUP_TYPE = setuptools
PYTHON_FALCON_LICENSE = Apache-2.0
PYTHON_FALCON_LICENSE_FILES = LICENSE

ifeq ($(BR2_PACKAGE_HOST_PYTHON_CYTHON),y)
PYTHON_FALCON_DEPENDENCIES += host-python-cython
endif

$(eval $(python-package))
