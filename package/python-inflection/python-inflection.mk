################################################################################
#
# python-inflection
#
################################################################################

PYTHON_INFLECTION_VERSION = 0.3.1
PYTHON_INFLECTION_SOURCE = inflection-$(PYTHON_INFLECTION_VERSION).tar.gz
PYTHON_INFLECTION_SITE = https://pypi.python.org/packages/d5/35/a6eb45b4e2356fe688b21570864d4aa0d0a880ce387defe9c589112077f8
PYTHON_INFLECTION_SETUP_TYPE = setuptools
PYTHON_INFLECTION_LICENSE = MIT
PYTHON_INFLECTION_LICENSE_FILES = LICENSE

$(eval $(python-package))
$(eval $(host-python-package))
