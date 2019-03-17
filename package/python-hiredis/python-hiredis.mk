################################################################################
#
# python-hiredis
#
################################################################################

PYTHON_HIREDIS_VERSION = 1.0.0
PYTHON_HIREDIS_SOURCE = hiredis-$(PYTHON_HIREDIS_VERSION).tar.gz
PYTHON_HIREDIS_SITE = https://files.pythonhosted.org/packages/9e/e0/c160dbdff032ffe68e4b3c576cba3db22d8ceffc9513ae63368296d1bcc8
PYTHON_HIREDIS_SETUP_TYPE = setuptools
PYTHON_HIREDIS_LICENSE = BSD-3-Clause
PYTHON_HIREDIS_LICENSE_FILES = COPYING vendor/hiredis/COPYING

$(eval $(python-package))
