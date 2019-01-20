################################################################################
#
# python-peewee
#
################################################################################

PYTHON_MARSHMALLOW_PEEWEE_VERSION = 2.2.0
PYTHON_MARSHMALLOW_PEEWEE_SOURCE = Marshmallow-Peewee-$(PYTHON_MARSHMALLOW_PEEWEE_VERSION).tar.gz
PYTHON_MARSHMALLOW_PEEWEE_SITE = https://files.pythonhosted.org/packages/51/4b/bac8c57eecb01810187b722e3f9e8c75f709f978b2cdaa0c2f94bcdae67e
PYTHON_MARSHMALLOW_PEEWEE_SETUP_TYPE = setuptools
PYTHON_MARSHMALLOW_PEEWEE_LICENSE = Apache-2.0
PYTHON_MARSHMALLOW_PEEWEE_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
