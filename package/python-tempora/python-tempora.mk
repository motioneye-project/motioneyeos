################################################################################
#
# python-tempora
#
################################################################################

PYTHON_TEMPORA_VERSION = 1.7
PYTHON_TEMPORA_SOURCE = tempora-$(PYTHON_TEMPORA_VERSION).tar.gz
PYTHON_TEMPORA_SITE = https://pypi.python.org/packages/db/2d/c838e9e553d774962a71b832b2c6390194904bfe49fd0d9d792ce8091e8a
PYTHON_TEMPORA_LICENSE = MIT
PYTHON_TEMPORA_SETUP_TYPE = setuptools
PYTHON_TEMPORA_DEPENDENCIES = host-python-setuptools-scm

$(eval $(python-package))
