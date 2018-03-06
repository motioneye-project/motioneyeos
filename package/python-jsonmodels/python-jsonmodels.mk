################################################################################
#
# python-jsonmodels
#
################################################################################

PYTHON_JSONMODELS_VERSION = 2.3
PYTHON_JSONMODELS_SOURCE = jsonmodels-$(PYTHON_JSONMODELS_VERSION).tar.gz
PYTHON_JSONMODELS_SITE = https://pypi.python.org/packages/ab/0f/e214845b49881d3b2bebd1f387eedc5b26ac5580353a0a38074e94439957
PYTHON_JSONMODELS_SETUP_TYPE = setuptools
PYTHON_JSONMODELS_LICENSE = BSD-3-Clause
PYTHON_JSONMODELS_LICENSE_FILES = LICENSE

$(eval $(python-package))
