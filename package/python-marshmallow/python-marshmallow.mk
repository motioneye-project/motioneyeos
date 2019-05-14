################################################################################
#
# python-marshmallow
#
################################################################################

PYTHON_MARSHMALLOW_VERSION = 3.0.0rc6
PYTHON_MARSHMALLOW_SOURCE = marshmallow-$(PYTHON_MARSHMALLOW_VERSION).tar.gz
PYTHON_MARSHMALLOW_SITE = https://files.pythonhosted.org/packages/91/0d/c91fc9cbc7e737ddc01d5b55900d7611ea52bd24c0660ea2e4df1a3e0ac9
PYTHON_MARSHMALLOW_SETUP_TYPE = setuptools
PYTHON_MARSHMALLOW_LICENSE = Apache-2.0
PYTHON_MARSHMALLOW_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
