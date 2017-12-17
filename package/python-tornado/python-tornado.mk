################################################################################
#
# python-tornado
#
################################################################################

PYTHON_TORNADO_VERSION = 4.5.1
PYTHON_TORNADO_SOURCE = tornado-$(PYTHON_TORNADO_VERSION).tar.gz
PYTHON_TORNADO_SITE = https://pypi.python.org/packages/df/42/a180ee540e12e2ec1007ac82a42b09dd92e5461e09c98bf465e98646d187
PYTHON_TORNADO_LICENSE = Apache-2.0
PYTHON_TORNADO_SETUP_TYPE = setuptools

$(eval $(python-package))
