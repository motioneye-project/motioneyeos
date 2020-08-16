################################################################################
#
# python-huepy
#
################################################################################

PYTHON_HUEPY_VERSION = a9851d5aea10d2299cc62b3f6dce26ac4ef2ea3e
PYTHON_HUEPY_SITE = $(call github,s0md3v,hue,$(PYTHON_HUEPY_VERSION))
PYTHON_HUEPY_LICENSE = GPL-3.0
PYTHON_HUEPY_LICENSE_FILES = LICENSE
PYTHON_HUEPY_SETUP_TYPE = setuptools

$(eval $(python-package))
