################################################################################
#
# python-pyrex
#
################################################################################

PYTHON_PYREX_VERSION = 0.9.9
PYTHON_PYREX_SOURCE = Pyrex-$(PYTHON_PYREX_VERSION).tar.gz
PYTHON_PYREX_SITE = http://www.cosc.canterbury.ac.nz/greg.ewing/python/Pyrex/
PYTHON_PYREX_DEPENDENCIES = host-python
PYTHON_PYREX_LICENSE = Apache-v2
PYTHON_PYREX_LICENSE_FILES = LICENSE.txt
PYTHON_PYREX_SETUP_TYPE = distutils

$(eval $(host-python-package))
