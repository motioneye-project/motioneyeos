################################################################################
#
# python-fire
#
################################################################################

PYTHON_FIRE_VERSION = 0.1.3
PYTHON_FIRE_SOURCE = fire-$(PYTHON_FIRE_VERSION).tar.gz
PYTHON_FIRE_SITE = https://files.pythonhosted.org/packages/5a/b7/205702f348aab198baecd1d8344a90748cb68f53bdcd1cc30cbc08e47d3e
PYTHON_FIRE_SETUP_TYPE = setuptools
PYTHON_FIRE_LICENSE = Apache-2.0
PYTHON_FIRE_LICENSE_FILES = LICENSE

$(eval $(python-package))
