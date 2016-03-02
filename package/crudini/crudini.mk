################################################################################
#
# crudini
#
################################################################################

CRUDINI_VERSION = 0.7
CRUDINI_SOURCE = crudini-$(CRUDINI_VERSION).tar.gz
CRUDINI_SITE = https://pypi.python.org/packages/source/c/crudini
CRUDINI_SETUP_TYPE = setuptools
CRUDINI_LICENSE = GPLv2
CRUDINI_LICENSE_FILES = COPYING

$(eval $(python-package))
