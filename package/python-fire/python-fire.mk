################################################################################
#
# python-fire
#
################################################################################

PYTHON_FIRE_VERSION = 0.2.1
PYTHON_FIRE_SOURCE = fire-$(PYTHON_FIRE_VERSION).tar.gz
PYTHON_FIRE_SITE = https://files.pythonhosted.org/packages/d9/69/faeaae8687f4de0f5973694d02e9d6c3eb827636a009157352d98de1129e
PYTHON_FIRE_SETUP_TYPE = setuptools
PYTHON_FIRE_LICENSE = Apache-2.0
PYTHON_FIRE_LICENSE_FILES = LICENSE

$(eval $(python-package))
