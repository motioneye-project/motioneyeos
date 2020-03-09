################################################################################
#
# python3-mako
#
################################################################################

# Please keep in sync with
# package/python-mako/python-mako.mk
PYTHON3_MAKO_VERSION = 1.1.1
PYTHON3_MAKO_SOURCE = Mako-$(PYTHON_MAKO_VERSION).tar.gz
PYTHON3_MAKO_SITE = https://files.pythonhosted.org/packages/28/03/329b21f00243fc2d3815399413845dbbfb0745cff38a29d3597e97f8be58
PYTHON3_MAKO_SETUP_TYPE = setuptools
PYTHON3_MAKO_LICENSE = MIT
PYTHON3_MAKO_LICENSE_FILES = LICENSE
HOST_PYTHON3_MAKO_DL_SUBDIR = python-mako
HOST_PYTHON3_MAKO_NEEDS_HOST_PYTHON = python3

$(eval $(host-python-package))
