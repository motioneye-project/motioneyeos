################################################################################
#
# python-rq
#
################################################################################

PYTHON_RQ_VERSION = 1.0
PYTHON_RQ_SOURCE = rq-$(PYTHON_RQ_VERSION).tar.gz
PYTHON_RQ_SITE = https://files.pythonhosted.org/packages/9d/f5/6a302ee297d8031ff955f26c0f38b043972fa5f45708f6865598bdac249f
PYTHON_RQ_SETUP_TYPE = setuptools
PYTHON_RQ_LICENSE = Apache-2.0
PYTHON_RQ_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
