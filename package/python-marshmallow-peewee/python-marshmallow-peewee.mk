################################################################################
#
# python-marshmallow-peewee
#
################################################################################

PYTHON_MARSHMALLOW_PEEWEE_VERSION = 2.3.0
PYTHON_MARSHMALLOW_PEEWEE_SOURCE = Marshmallow-Peewee-$(PYTHON_MARSHMALLOW_PEEWEE_VERSION).tar.gz
PYTHON_MARSHMALLOW_PEEWEE_SITE = https://files.pythonhosted.org/packages/55/de/880e245416171d3fcc20cf47562d17ef7ce81bfbf727ec0e268c06264bde
PYTHON_MARSHMALLOW_PEEWEE_SETUP_TYPE = setuptools
PYTHON_MARSHMALLOW_PEEWEE_LICENSE = Apache-2.0
PYTHON_MARSHMALLOW_PEEWEE_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
