################################################################################
#
# python-pymongo
#
################################################################################

PYTHON_PYMONGO_VERSION = 3.4.0
PYTHON_PYMONGO_SOURCE = pymongo-$(PYTHON_PYMONGO_VERSION).tar.gz
PYTHON_PYMONGO_SITE = https://pypi.python.org/packages/82/26/f45f95841de5164c48e2e03aff7f0702e22cef2336238d212d8f93e91ea8
PYTHON_PYMONGO_SETUP_TYPE = setuptools

$(eval $(python-package))
