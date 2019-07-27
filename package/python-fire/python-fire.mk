################################################################################
#
# python-fire
#
################################################################################

PYTHON_FIRE_VERSION = 0.2.0
PYTHON_FIRE_SOURCE = fire-$(PYTHON_FIRE_VERSION).tar.gz
PYTHON_FIRE_SITE = https://files.pythonhosted.org/packages/40/6e/48cf0cffb7bf0bb58746bff99ed2d1a2769a32c4d74c06f988eb3e554f86
PYTHON_FIRE_SETUP_TYPE = setuptools
PYTHON_FIRE_LICENSE = Apache-2.0
PYTHON_FIRE_LICENSE_FILES = LICENSE

$(eval $(python-package))
