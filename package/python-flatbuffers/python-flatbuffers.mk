################################################################################
#
# python-flatbuffers
#
################################################################################

PYTHON_FLATBUFFERS_VERSION = 1.11
PYTHON_FLATBUFFERS_SOURCE = flatbuffers-$(PYTHON_FLATBUFFERS_VERSION).tar.gz
PYTHON_FLATBUFFERS_SITE = https://files.pythonhosted.org/packages/c6/b6/21478b76aa7ccab58da3beb85746b6844dee2112c0cc25b51ec64b46bdbb
PYTHON_FLATBUFFERS_LICENSE = Apache-2.0
PYTHON_FLATBUFFERS_SETUP_TYPE = setuptools

$(eval $(python-package))
