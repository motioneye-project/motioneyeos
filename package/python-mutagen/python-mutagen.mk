################################################################################
#
# python-mutagen
#
################################################################################

PYTHON_MUTAGEN_VERSION = 1.36.2
PYTHON_MUTAGEN_SOURCE = mutagen-$(PYTHON_MUTAGEN_VERSION).tar.gz
PYTHON_MUTAGEN_SITE = https://pypi.python.org/packages/e7/8a/61496657e30c2cbeb9b3aa28848e0adbcba7cab0ff0bd8e6206647670088
PYTHON_MUTAGEN_LICENSE = GPL-2.0
PYTHON_MUTAGEN_LICENSE_FILES = COPYING
PYTHON_MUTAGEN_SETUP_TYPE = distutils

$(eval $(python-package))
