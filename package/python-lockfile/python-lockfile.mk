################################################################################
#
# python-lockfile
#
################################################################################

PYTHON_LOCKFILE_VERSION = 0.12.2
PYTHON_LOCKFILE_SOURCE = lockfile-$(PYTHON_LOCKFILE_VERSION).tar.gz
PYTHON_LOCKFILE_SITE = https://files.pythonhosted.org/packages/17/47/72cb04a58a35ec495f96984dddb48232b551aafb95bde614605b754fe6f7
PYTHON_LOCKFILE_SETUP_TYPE = setuptools
PYTHON_LOCKFILE_LICENSE = MIT
PYTHON_LOCKFILE_LICENSE_FILES = LICENSE
PYTHON_LOCKFILE_DEPENDENCIES = host-python-pbr

$(eval $(python-package))
