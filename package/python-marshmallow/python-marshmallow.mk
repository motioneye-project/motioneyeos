################################################################################
#
# python-marshmallow
#
################################################################################

PYTHON_MARSHMALLOW_VERSION = 3.0.0rc5
PYTHON_MARSHMALLOW_SOURCE = marshmallow-$(PYTHON_MARSHMALLOW_VERSION).tar.gz
PYTHON_MARSHMALLOW_SITE = https://files.pythonhosted.org/packages/71/78/b27626d937534d513b7de5a3210c071bc2de0721bdc72594e7d9d42beea2
PYTHON_MARSHMALLOW_SETUP_TYPE = setuptools
PYTHON_MARSHMALLOW_LICENSE = Apache-2.0
PYTHON_MARSHMALLOW_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
