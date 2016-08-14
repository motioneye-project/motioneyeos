################################################################################
#
# python-service-identity
#
################################################################################

PYTHON_SERVICE_IDENTITY_VERSION = 14.0.0
PYTHON_SERVICE_IDENTITY_SOURCE = service_identity-$(PYTHON_SERVICE_IDENTITY_VERSION).tar.gz
PYTHON_SERVICE_IDENTITY_SITE = http://pypi.python.org/packages/source/s/service_identity
PYTHON_SERVICE_IDENTITY_LICENSE = MIT
PYTHON_SERVICE_IDENTITY_LICENSE_FILES = LICENSE
PYTHON_SERVICE_IDENTITY_SETUP_TYPE = setuptools

$(eval $(python-package))
