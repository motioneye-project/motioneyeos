################################################################################
#
# python-whoosh
#
################################################################################

PYTHON_WHOOSH_VERSION = 2.7.4
PYTHON_WHOOSH_SOURCE = Whoosh-$(PYTHON_WHOOSH_VERSION).tar.gz
PYTHON_WHOOSH_SITE = https://pypi.python.org/packages/25/2b/6beed2107b148edc1321da0d489afc4617b9ed317ef7b72d4993cad9b684
PYTHON_WHOOSH_SETUP_TYPE = setuptools
PYTHON_WHOOSH_LICENSE = BSD-3-Clause
PYTHON_WHOOSH_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
