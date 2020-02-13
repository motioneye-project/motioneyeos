################################################################################
#
# python-mako
#
################################################################################

# Please keep in sync with
# package/python3-mako/python3-mako.mk
PYTHON_MAKO_VERSION = 1.1.1
PYTHON_MAKO_SOURCE = Mako-$(PYTHON_MAKO_VERSION).tar.gz
PYTHON_MAKO_SITE = https://files.pythonhosted.org/packages/28/03/329b21f00243fc2d3815399413845dbbfb0745cff38a29d3597e97f8be58
PYTHON_MAKO_SETUP_TYPE = setuptools
PYTHON_MAKO_LICENSE = MIT
PYTHON_MAKO_LICENSE_FILES = LICENSE

# In host build, setup.py tries to download markupsafe if it is not installed
HOST_PYTHON_MAKO_DEPENDENCIES = host-python-markupsafe

$(eval $(python-package))
$(eval $(host-python-package))
