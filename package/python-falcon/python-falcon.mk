################################################################################
#
# python-falcon
#
################################################################################

PYTHON_FALCON_VERSION = 1.4.1
PYTHON_FALCON_SOURCE = falcon-$(PYTHON_FALCON_VERSION).tar.gz
PYTHON_FALCON_SITE = https://files.pythonhosted.org/packages/2f/e6/5045da9df509b9259037f065d15608930fd6c997ee930ad230f9fbfecf15
PYTHON_FALCON_SETUP_TYPE = setuptools
PYTHON_FALCON_LICENSE = Apache-2.0
PYTHON_FALCON_LICENSE_FILES = LICENSE

ifeq ($(BR2_PACKAGE_HOST_PYTHON_CYTHON),y)
PYTHON_FALCON_DEPENDENCIES += host-python-cython
endif

$(eval $(python-package))
