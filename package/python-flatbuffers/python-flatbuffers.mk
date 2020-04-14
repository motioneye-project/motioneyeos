################################################################################
#
# python-flatbuffers
#
################################################################################

PYTHON_FLATBUFFERS_VERSION = 1.12
PYTHON_FLATBUFFERS_SOURCE = flatbuffers-$(PYTHON_FLATBUFFERS_VERSION).tar.gz
PYTHON_FLATBUFFERS_SITE = https://files.pythonhosted.org/packages/4d/c4/7b995ab9bf0c7eaf10c386d29a03408dfcf72648df4102b1f18896c3aeea
PYTHON_FLATBUFFERS_LICENSE = Apache-2.0
PYTHON_FLATBUFFERS_SETUP_TYPE = setuptools

$(eval $(python-package))
