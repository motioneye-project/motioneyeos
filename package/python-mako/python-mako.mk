################################################################################
#
# python-mako
#
################################################################################

PYTHON_MAKO_VERSION = 1.0.3
PYTHON_MAKO_SOURCE = Mako-$(PYTHON_MAKO_VERSION).tar.gz
PYTHON_MAKO_SITE = https://pypi.python.org/packages/source/M/Mako
PYTHON_MAKO_SETUP_TYPE = setuptools
PYTHON_MAKO_LICENSE = MIT
PYTHON_MAKO_LICENSE_FILES = LICENSE

# In host build, setup.py tries to download markupsafe if it is not installed
HOST_PYTHON_MAKO_DEPENDENCIES = host-python-markupsafe

$(eval $(python-package))
$(eval $(host-python-package))
