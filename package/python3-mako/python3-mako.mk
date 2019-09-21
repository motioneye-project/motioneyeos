################################################################################
#
# python3-mako
#
################################################################################

# Please keep in sync with
# package/python-mako/python-mako.mk
PYTHON3_MAKO_VERSION = 1.0.6
PYTHON3_MAKO_SOURCE = Mako-$(PYTHON_MAKO_VERSION).tar.gz
PYTHON3_MAKO_SITE = https://pypi.python.org/packages/56/4b/cb75836863a6382199aefb3d3809937e21fa4cb0db15a4f4ba0ecc2e7e8e
PYTHON3_MAKO_SETUP_TYPE = setuptools
PYTHON3_MAKO_LICENSE = MIT
PYTHON3_MAKO_LICENSE_FILES = LICENSE
HOST_PYTHON3_MAKO_DL_SUBDIR = python-mako
HOST_PYTHON3_MAKO_NEEDS_HOST_PYTHON = python3

$(eval $(host-python-package))
