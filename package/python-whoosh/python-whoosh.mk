################################################################################
#
# python-whoosh
#
################################################################################

PYTHON_WHOOSH_VERSION = 2.7.0
PYTHON_WHOOSH_SOURCE = Whoosh-$(PYTHON_WHOOSH_VERSION).tar.gz
PYTHON_WHOOSH_SITE = http://pypi.python.org/packages/source/W/Whoosh
PYTHON_WHOOSH_SETUP_TYPE = setuptools
PYTHON_WHOOSH_LICENSE = BSD-3c
PYTHON_WHOOSH_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
