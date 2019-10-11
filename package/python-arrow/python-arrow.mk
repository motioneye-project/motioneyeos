################################################################################
#
# python-arrow
#
################################################################################

PYTHON_ARROW_VERSION = 0.15.2
PYTHON_ARROW_SOURCE = arrow-$(PYTHON_ARROW_VERSION).tar.gz
PYTHON_ARROW_SITE = https://files.pythonhosted.org/packages/43/0e/47416c54ad7742981bf77fdfc405987551ab14b181a6140c8cd2a5823872
PYTHON_ARROW_SETUP_TYPE = setuptools
PYTHON_ARROW_LICENSE = Apache-2.0
PYTHON_ARROW_LICENSE_FILES = LICENSE

$(eval $(python-package))
