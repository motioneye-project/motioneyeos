################################################################################
#
# python3-mako
#
################################################################################

# Please keep in sync with
# package/python-mako/python-mako.mk
PYTHON3_MAKO_VERSION = 1.1.0
PYTHON3_MAKO_SOURCE = Mako-$(PYTHON_MAKO_VERSION).tar.gz
PYTHON3_MAKO_SITE = https://files.pythonhosted.org/packages/b0/3c/8dcd6883d009f7cae0f3157fb53e9afb05a0d3d33b3db1268ec2e6f4a56b
PYTHON3_MAKO_SETUP_TYPE = setuptools
PYTHON3_MAKO_LICENSE = MIT
PYTHON3_MAKO_LICENSE_FILES = LICENSE
HOST_PYTHON3_MAKO_DL_SUBDIR = python-mako
HOST_PYTHON3_MAKO_NEEDS_HOST_PYTHON = python3

$(eval $(host-python-package))
