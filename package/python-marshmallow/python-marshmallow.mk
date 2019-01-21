################################################################################
#
# python-marshmallow
#
################################################################################

PYTHON_MARSHMALLOW_VERSION = 3.0.0b20
PYTHON_MARSHMALLOW_SOURCE = marshmallow-$(PYTHON_MARSHMALLOW_VERSION).tar.gz
PYTHON_MARSHMALLOW_SITE = https://files.pythonhosted.org/packages/9b/dd/c6125334e434794754bf7fdc85bd9a26bdd3b1734471562a2b1ccd6e5802
PYTHON_MARSHMALLOW_SETUP_TYPE = setuptools
PYTHON_MARSHMALLOW_LICENSE = Apache-2.0
PYTHON_MARSHMALLOW_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
