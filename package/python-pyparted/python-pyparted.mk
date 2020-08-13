################################################################################
#
# python-pyparted
#
################################################################################

PYTHON_PYPARTED_VERSION = 3.11.0
PYTHON_PYPARTED_SITE = $(call github,rhinstaller,pyparted,v$(PYTHON_PYPARTED_VERSION))
PYTHON_PYPARTED_SETUP_TYPE = distutils
PYTHON_PYPARTED_LICENSE = GPL-2.0+
PYTHON_PYPARTED_LICENSE_FILES = COPYING
PYTHON_PYPARTED_DEPENDENCIES = parted

$(eval $(python-package))
