################################################################################
#
# python-pyparted
#
################################################################################

PYTHON_PYPARTED_VERSION = v3.10.7
PYTHON_PYPARTED_SITE = $(call github,rhinstaller,pyparted,$(PYTHON_PYPARTED_VERSION))
PYTHON_PYPARTED_SETUP_TYPE = distutils
PYTHON_PYPARTED_LICENSE = GPL-2.0+
PYTHON_PYPARTED_LICENSE_FILES = COPYING
PYTHON_PYPARTED_DEPENDENCIES = host-python-cffi parted

$(eval $(python-package))
